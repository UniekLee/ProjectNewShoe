import ComposableArchitecture
import SwiftUI

@main
struct ProjectNewShoeApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(
                store: Store(
                    initialState: AppState(),
                    reducer: appReducer,
                    environment: AppEnvironment(
                        workoutLoader: WorkoutLoader().load
                    )
                )
            )
        }
    }
}
