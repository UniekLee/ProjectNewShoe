import Foundation
import HealthKit

extension WorkoutState {
    init(hkWorkout: HKWorkout) {
        self.id = hkWorkout.uuid

        self.iconName = hkWorkout.image
        self.name = hkWorkout.name
        self.date = Date.removingTime(from: hkWorkout.startDate)
        self.time = Formatter.time.string(from: hkWorkout.startDate)
        self.distance = hkWorkout.totalDistanceInM

        self.isIncluded = Persistence.shared.isIncluded(hkWorkout.uuid)
    }
}

extension HKWorkout {
    var image: String {
        switch workoutActivityType {
        case .walking: return "πΆπΌβ¨"
        case .running: return "ππ»ββοΈπ¨"
        default: return "π€·π»ββοΈ"
        }
    }

    var name: String {
        switch workoutActivityType {
        case .walking: return "Walk"
        case .running: return "Run"
        default: return "Oopsie"
        }
    }

    var totalDistanceInM: Int {
        Int((
            totalDistance?.doubleValue(
                for: HKUnit.meter()
            ) ?? 0
        ))
    }
}
