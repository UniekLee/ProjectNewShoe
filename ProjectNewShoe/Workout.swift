//
//  Workout.swift
//  ProjectNewShoe
//
//  Created by Lee Watkins on 24/06/2021.
//

import Foundation
import HealthKit

struct Workout: Identifiable {
    let id: UUID

    let iconName: String
    let name: String
    let date: String
    let distance: String

    var isIncluded: Bool
}

extension Workout {
    init(hkWorkout: HKWorkout) {
        self.id = hkWorkout.uuid

        self.iconName = hkWorkout.image
        self.name = hkWorkout.name
        self.date = Formatter.date.string(from: hkWorkout.startDate)
        self.distance = "\(hkWorkout.totalDistanceInKM) km"

        self.isIncluded = Persistence.shared.isIncluded(hkWorkout.uuid)
    }
}

extension HKWorkout {
    var image: String {
        switch workoutActivityType {
        case .walking: return "figure.walk"
        case .running: return "bolt.heart.fill"
        default: return "cross.fill"
        }
    }

    var name: String {
        switch workoutActivityType {
        case .walking: return "Walk"
        case .running: return "Run"
        default: return "Oopsie"
        }
    }

    var totalDistanceInKM: Double {
        round(
            (totalDistance?.doubleValue(
                for: HKUnit.meterUnit(with: .kilo)
            ) ?? 0) * 100
        ) / 100
    }
}
