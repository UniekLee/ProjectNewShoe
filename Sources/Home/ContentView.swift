import SwiftUI
import HealthKit
import ComposableArchitecture

enum WorkoutLookupError: Error {
    case unknown
}

enum LoadState: Equatable {
    case notLoaded
    case loading
    case loaded
}

// Core domain of the app
struct AppState: Equatable {
    var loadState: LoadState = .notLoaded
    var workouts: [Workout] = []
    var workoutLookupErrorMessage: String?
    var totalDistanceOfIncludedWorkouts: Int = 0
}

enum AppAction {
    case viewAppeared
    case workoutFetchResponse(Result<[Workout], WorkoutLookupError>)
    case workout(index: Int, action: WorkoutAction)
}

struct AppEnvironment {
    let workoutLoader: () -> Effect<[Workout], WorkoutLookupError>
}

let appReducer: Reducer<AppState, AppAction, AppEnvironment> = .combine(
    [
        workoutReducer.forEach(
            state: \AppState.workouts,
            action: /AppAction.workout(index:action:),
            environment: { _ in WorkoutEnvironment(
                toggleSelection: { workout in
                    let isIncluded = Persistence.shared.toggle(workout: workout)
                    return Effect(value: isIncluded)
                }
            ) }
        ),
        Reducer { state, action, environment in
            switch action {
            case .workout:
                state.totalDistanceOfIncludedWorkouts = state.workouts
                    .filter({ $0.isIncluded })
                    .reduce(0, { $0 + $1.distance })
                return .none
            case .viewAppeared:
                state.loadState = .loading
                return environment
                    .workoutLoader()
                    .catchToEffect()
                    .map(AppAction.workoutFetchResponse)
            case .workoutFetchResponse(.success(let workouts)):
                state.loadState = .loaded
                state.workouts = workouts
                state.totalDistanceOfIncludedWorkouts = state.workouts
                    .filter({ $0.isIncluded })
                    .reduce(0, { $0 + $1.distance })
                return .none
            case .workoutFetchResponse(.failure):
                state.workoutLookupErrorMessage = "Couldn't fetch workouts"
                state.loadState = .loaded
                return .none
            }
        }
    ]
).debug()

struct ContentView: View {
    let store: Store<AppState, AppAction>

    var body: some View {
        WithViewStore(self.store) { viewStore in
            NavigationView {
                VStack {
                    HStack {
                        Text("Total distance")
                        Spacer()
                        Text("\(viewStore.totalDistanceOfIncludedWorkouts.asRoundedKM, specifier: "%.2f") km / 800 km")
                    }.padding()
                    List {
                        ForEachStore(
                            self.store.scope(
                                state: \.workouts,
                                action: AppAction.workout(index:action:)
                            ),
                            content: WorkoutView.init(store:)
                        )
                    }
                }
                .navigationTitle("Project New Shoe")
            }
            .onAppear {
                viewStore.send(.viewAppeared)
            }
        }
    }
//        NavigationView {
//            switch state {
//            case .loading:
//                Text("Loading")
//            case .noData:
//                Text("No data")
//            case .loaded(let workouts):
//                WorkoutListView(viewModel: WorkoutListViewModel(workouts: workouts))
//            }
//        }
//    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(
            store: Store(
                initialState: AppState(workouts: []),
                reducer: appReducer,
                environment: AppEnvironment(
                    workoutLoader: { Effect(value: Workout.mockWorkouts) }
                )
            )
        )
    }
}

extension Workout {
    static let mockWorkouts: [Workout] = [
        Workout(
            id: UUID(),
            iconName: "🏃🏻‍♂️💨",
            name: "Run",
            date: "5 June",
            distance: 1234,
            isIncluded: true
        ),
        Workout(
            id: UUID(),
            iconName: "🚶🏻‍♂️✨",
            name: "Walk",
            date: "3 June",
            distance: 9256,
            isIncluded: false
        ),
        Workout(
            id: UUID(),
            iconName: "🏃🏻‍♂️💨",
            name: "Run",
            date: "1 June",
            distance: 2693,
            isIncluded: true
        )
    ]
}
