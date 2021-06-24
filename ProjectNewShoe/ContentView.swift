//
//  ContentView.swift
//  ProjectNewShoe
//
//  Created by Lee Watkins on 15/06/2021.
//

import SwiftUI
import HealthKit

struct ContentView: View {
    @ObservedObject var loader = WorkoutLoader()

    var body: some View {
        List {
            ForEach(loader.workouts) { workout in
                    HStack {
                        workout.icon
                        VStack(alignment: .leading) {
                            Text(workout.name).font(.body)
                            Text(workout.date).font(.footnote)
                        }
                        Spacer()
                        Text(workout.distance)
                    }
            }
        }
        .onAppear(
            perform: {
                loader.load()
            }
        )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Workout: Identifiable {
    let id: UUID

    let icon: Image
    let name: String
    let date: String
    let distance: String

    let isIncluded: Bool
}

extension Workout {
    init(hkWorkout: HKWorkout) {
        self.id = hkWorkout.uuid

        self.icon = hkWorkout.image
        self.name = hkWorkout.name
        self.date = Formatter.date.string(from: hkWorkout.startDate)
        self.distance = "\(hkWorkout.totalDistanceInKM) km"

        self.isIncluded = false
    }
}

extension HKWorkout {
    var image: Image {
        switch workoutActivityType {
        case .walking: return Image(systemName: "figure.walk")
        case .running: return Image(systemName: "bolt.heart.fill")
        default: return Image(systemName: "cross.fill")
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
