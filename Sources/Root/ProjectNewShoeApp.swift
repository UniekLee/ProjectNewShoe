//
//  ProjectNewShoeApp.swift
//  ProjectNewShoe
//
//  Created by Lee Watkins on 15/06/2021.
//

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
                    environment: AppEnvironment()
                )
            )
        }
    }
}
