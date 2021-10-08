import Foundation

public class Persistence {
    private static let selectedWorkoutKeys = "selected_workout_ids"
    public typealias DomainWorkout = Dictionary<UUID, Bool>
    public typealias PersistenceWorkout = Dictionary<String, Bool>


    public static let shared: Persistence = Persistence()
    private let defaults = UserDefaults.standard

    private var workoutSelection: DomainWorkout = [:] {
        didSet {
            defaults.set(
                persistenceModel(for: workoutSelection),
                forKey: Persistence.selectedWorkoutKeys
            )
        }
    }

    public init() {
        let workoutSelectionDb = defaults.object(forKey: Persistence.selectedWorkoutKeys) as? PersistenceWorkout ?? [:]
        self.workoutSelection = domainModel(for: workoutSelectionDb)
    }

    public func toggle(workout: Workout) -> Bool {
        workoutSelection[workout.id] = !workout.isIncluded
        return isIncluded(workout.id)
    }

    public func isIncluded(_ id: UUID) -> Bool {
        workoutSelection[id] ?? false
    }
}

private extension Persistence {
    func domainModel(for persistenceModel: PersistenceWorkout) -> DomainWorkout {
        persistenceModel.reduce(into: DomainWorkout()) { partialResult, next in
            guard let key = UUID(uuidString: next.key) else { return }
            partialResult[key] = next.value
        }
    }

    func persistenceModel(for domainModel: DomainWorkout) -> PersistenceWorkout {
        domainModel.reduce(into: PersistenceWorkout()) { partialResult, next in
            partialResult[next.key.uuidString] = next.value
        }
    }
}
