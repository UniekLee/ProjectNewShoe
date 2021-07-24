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
                    environment: AppEnvironment()
                )
            )
        }
    }
}
