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

    init(workouts: [Workout]) {
        self.workoutViewModels = workouts.map { workout in
            WorkoutViewModel(workout: workout)
        }
    }
}
