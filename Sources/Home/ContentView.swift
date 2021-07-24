import SwiftUI
import HealthKit
import ComposableArchitecture

// Core domain of the app
struct AppState: Equatable {
    var workouts: [Workout]
}

enum AppAction {
    case workout(index: Int, action: WorkoutAction)
}

struct AppEnvironment {}

let appReducer: Reducer<AppState, AppAction, AppEnvironment> =
    workoutReducer.forEach(
        state: \AppState.workouts,
        action: /AppAction.workout(index:action:),
        environment: { _ in WorkoutEnvironment() }
    )
    .debug()

struct ContentView: View {
    let store: Store<AppState, AppAction>

    enum DataState {
        case loading, noData
        case loaded(workouts: [Workout])
    }

    private let loader = WorkoutLoader()
    @State private var state: DataState = .loading

    var body: some View {
        NavigationView {
            WithViewStore(self.store) { viewStore in
                List {
                    ForEachStore(
                        self.store.scope(
                            state: { $0.workouts },
                            action: { AppAction.workout(index: $0, action: $1) }
                        )
                    ) { workoutStore in
                        WithViewStore(workoutStore) { workoutViewStore in
                            HStack {
                                Image(systemName: workoutViewStore.iconName)
                                VStack(alignment: .leading) {
                                    Text(workoutViewStore.name).font(.body)
                                    Text(workoutViewStore.date).font(.footnote)
                                }
                                Spacer()
                                Text("\(workoutViewStore.distance.asRoundedKM)")
                                Image(systemName: workoutViewStore.isIncluded ? "checkmark.circle.fill" : "circle")
                            }
                            .onTapGesture {
                                workoutViewStore.send(.inclusionToggled)
                            }
                        }
                    }
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
//        .onAppear {
//            loader.load { workouts in
//                if workouts.isEmpty {
//                    self.state = .noData
//                } else {
//                    self.state = .loaded(workouts: workouts)
//                }
//            }
//        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(
            store: Store(
                initialState: AppState(workouts: []),
                reducer: appReducer,
                environment: AppEnvironment()
            )
        )
    }
}
