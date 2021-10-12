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
    var dateSections: [DateSectionState] = []
    var workoutLookupErrorMessage: String?
    var totalDistanceOfIncludedWorkouts: Int = 0
}

enum AppAction {
    case viewAppeared
    case workoutFetchResponse(Result<[Workout], WorkoutLookupError>)
    case section(index: Int, action: DateSectionAction)
}

struct AppEnvironment {
    let workoutLoader: () -> Effect<[Workout], WorkoutLookupError>
}

let appReducer: Reducer<AppState, AppAction, AppEnvironment> = .combine(
    [
        dateSectionReducer.forEach(
            state: \AppState.dateSections,
            action: /AppAction.section(index:action:),
            environment: { _ in DateSectionEnvironment() }
        ),
        Reducer { state, action, environment in
            switch action {
            case .section:
                state.totalDistanceOfIncludedWorkouts = state.dateSections
                    .flatMap(\.workouts)
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
                state.dateSections = Dictionary(
                    grouping: workouts,
                    by: { $0.date }
                ).map { key, value in
                    DateSectionState(title: key, workouts: value)
                }
                state.totalDistanceOfIncludedWorkouts = state.dateSections
                    .flatMap(\.workouts)
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
                                state: \.dateSections,
                                action: AppAction.section(index:action:)
                            ),
                            content: DateSectionView.init(store:)
                        )
                    }.listStyle(InsetGroupedListStyle())
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
                initialState: AppState(),
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
            time: "05:37",
            distance: 1234,
            isIncluded: true
        ),
        Workout(
            id: UUID(),
            iconName: "🚶🏻‍♂️✨",
            name: "Walk",
            date: "3 June",
            time: "05:37",
            distance: 9256,
            isIncluded: false
        ),
        Workout(
            id: UUID(),
            iconName: "🏃🏻‍♂️💨",
            name: "Run",
            date: "1 June",
            time: "05:37",
            distance: 2693,
            isIncluded: true
        )
    ]
}
