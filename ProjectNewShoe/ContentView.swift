//
//  ContentView.swift
//  ProjectNewShoe
//
//  Created by Lee Watkins on 15/06/2021.
//

import SwiftUI
import HealthKit

struct ContentView: View {
    @ObservedObject var loader = WorkoutLoader()

    var body: some View {
        NavigationView {
            WorkoutListView(loader: loader)
        }
        .onAppear(
            perform: {
                loader.load()
            }
        )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
