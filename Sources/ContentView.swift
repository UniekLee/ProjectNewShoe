//
//  ContentView.swift
//  ProjectNewShoe
//
//  Created by Lee Watkins on 15/06/2021.
//

import SwiftUI
import HealthKit

struct ContentView: View {
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
        ContentView()
    }
}
