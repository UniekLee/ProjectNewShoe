import ComposableArchitecture
import SwiftUI

@main
struct ProjectNewShoeApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(
                store: Store(
                    initialState: AppState(workouts: []),
                    reducer: appReducer,
                    environment: AppEnvironment(
                        // Need to figure out how to execture the WorkoutLoader().load func
                        // And pass/map the result of that into an Effect.
                        workoutLoader: { () -> Effect<[Workout], WorkoutLookupError> in
                            return Effect(value: <#T##_#>) WorkoutLoader().load
                        }
                    )
                )
            )
        }
    }
}
