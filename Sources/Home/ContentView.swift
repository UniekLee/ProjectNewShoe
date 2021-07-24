import SwiftUI
import HealthKit
import ComposableArchitecture

// Core domain of the app
struct AppState {
}

enum AppAction {
}

struct AppEnvironment {
}

let appReducer = Reducer<AppState, AppAction, AppEnvironment> { state, action, environment in
    // Business logic goes here. That means:
    // 1. Make any mutations to the State, necessary for the Action. (Pure logic)
    // 2. After all mutations, return an Effect. ("Impure" logic, ie: side-effects)
    // That's all that can happen here.
    switch action {

    }
}

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
            switch state {
            case .loading:
                Text("Loading")
            case .noData:
                Text("No data")
            case .loaded(let workouts):
                WorkoutListView(viewModel: WorkoutListViewModel(workouts: workouts))
            }
        }
        .onAppear {
            loader.load { workouts in
                if workouts.isEmpty {
                    self.state = .noData
                } else {
                    self.state = .loaded(workouts: workouts)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(
            store: Store(
                initialState: AppState(),
                reducer: appReducer,
                environment: AppEnvironment()
            )
        )
    }
}
