//
//  WorkoutViewModel.swift
//  ProjectNewShoe
//
//  Created by Lee Watkins on 28/06/2021.
//

import Foundation
import Combine

class WorkoutViewModel: ObservableObject, Identifiable {
    @Published var workout: Workout

    var id: UUID = UUID()
    @Published var inclusionStateIconName = ""
    @Published var distance: String = ""

    private var cancellables = Set<AnyCancellable>()

    init(workout: Workout) {
        self.workout = workout

        $workout
            .map { $0.isIncluded ? "checkmark.circle.fill" : "circle" }
            .assign(to: \.inclusionStateIconName, on: self)
            .store(in: &cancellables)

        $workout
            .map { $0.id }
            .assign(to: \.id, on: self)
            .store(in: &cancellables)

        $workout
            .map { $0.distance.asRoundedKM }
            .map { "\($0) km" }
            .assign(to: \.distance, on: self)
            .store(in: &cancellables)
    }

    func toggleInclusion() {
        Persistence.shared.toggle(workout: workout)
        workout.isIncluded.toggle()
    }
}

extension Int {
    var asRoundedKM: Double { round((Double(self) / 10)) / 100 }
}