import Foundation
import HealthKit

extension Workout {
    init(hkWorkout: HKWorkout) {
        self.id = hkWorkout.uuid

        self.iconName = hkWorkout.image
        self.name = hkWorkout.name
        self.date = Formatter.date.string(from: hkWorkout.startDate)
        self.time = Formatter.time.string(from: hkWorkout.startDate)
        self.distance = hkWorkout.totalDistanceInM

        self.isIncluded = Persistence.shared.isIncluded(hkWorkout.uuid)
    }
}

extension HKWorkout {
    var image: String {
        switch workoutActivityType {
        case .walking: return "🚶🏼✨"
        case .running: return "🏃🏻‍♂️💨"
        default: return "🤷🏻‍♂️"
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
