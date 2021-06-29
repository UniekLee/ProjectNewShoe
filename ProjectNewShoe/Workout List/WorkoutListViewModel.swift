//
//  WorkoutListViewModel.swift
//  ProjectNewShoe
//
//  Created by Lee Watkins on 28/06/2021.
//

import Foundation
import Combine

class WorkoutListViewModel: ObservableObject {
    @Published var workoutViewModels: [WorkoutViewModel] = []
    
    var totalDistance: Int {
        workoutViewModels
            .filter({ $0.workout.isIncluded })
            .reduce(into: 0) { total, next in
                total += next.workout.distance
            }
    }

    init(workouts: [Workout]) {
        self.workoutViewModels = workouts.map { workout in
            WorkoutViewModel(workout: workout)
        }
    }
}
