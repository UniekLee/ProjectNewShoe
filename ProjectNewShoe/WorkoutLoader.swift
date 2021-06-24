//
//  WorkoutLoader.swift
//  ProjectNewShoe
//
//  Created by Lee Watkins on 15/06/2021.
//

import Foundation
import HealthKit

extension HKWorkout: Identifiable {
    public var id: UUID { uuid }
}

class WorkoutLoader: ObservableObject {
    private let store: HKHealthStore
    @Published var workouts: [Workout] = []

    init() {
        guard HKHealthStore.isHealthDataAvailable() else { fatalError("HealthKit unavailable") }
        self.store = HKHealthStore()
    }

    func load() {
        let workouts = Set([HKObjectType.workoutType()])

        store.requestAuthorization(toShare: [], read: workouts) { (success, error) in
            if !success {
                // Handle the error here.
            } else {
                self.loadSources { sources in
                    self.loadWorkouts(from: sources) { (workoutsOrNil, errorOrNil) in
                        guard let hkWorkouts = workoutsOrNil
                        else { fatalError("No workouts") }
                        self.workouts = hkWorkouts.map({ Workout(hkWorkout: $0) })
                    }
                }
            }
        }
    }

    private func loadSources(completion: @escaping (Set<HKSource>) -> Void) {
        let workouts = HKObjectType.workoutType()
        let query = HKSourceQuery(
            sampleType: workouts,
            samplePredicate: nil
        ) { (query, sourcesOrNil, errorOrNil) in
            guard let sources = sourcesOrNil else { fatalError("No sources available") }
            DispatchQueue.main.async {
                completion(sources)
            }
        }

        store.execute(query)
    }

    private func loadWorkouts(
        from sources: Set<HKSource>,
        completion: @escaping ([HKWorkout]?, Error?) -> Void
    ) {
        let walkingPredicate = HKQuery.predicateForWorkouts(with: .walking)
        let runningPredicate = HKQuery.predicateForWorkouts(with: .running)
        let sourcePredicate = HKQuery.predicateForObjects(from: sources)

        let activityPredicate = NSCompoundPredicate(
            orPredicateWithSubpredicates: [walkingPredicate, runningPredicate]
        )

        let compoundPredicate = NSCompoundPredicate(
            andPredicateWithSubpredicates: [activityPredicate, sourcePredicate]
        )

        let sortDescriptor = NSSortDescriptor(
            key: HKSampleSortIdentifierEndDate,
            ascending: false
        )

        let query = HKSampleQuery(
            sampleType: .workoutType(),
            predicate: compoundPredicate,
            limit: 0,
            sortDescriptors: [sortDescriptor]
        ) { (query, samples, error) in
            DispatchQueue.main.async {
                guard
                    let samples = samples as? [HKWorkout],
                    error == nil
                else {
                    completion(nil, error)
                    return
                }

                completion(samples, nil)
            }
        }

        store.execute(query)
    }
}
