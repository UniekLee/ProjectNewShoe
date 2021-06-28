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

    private var cancellables = Set<AnyCancellable>()

    init(workouts: [Workout]) {
        self.workoutViewModels = workouts.map { workout in
            WorkoutViewModel(workout: workout)
        }
    }

    func toggleInclusion(of workout: Workout) {
        Persistence.shared.toggle(workout: workout)
    }
}
