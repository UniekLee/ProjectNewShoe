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
                        Image(
                            systemName:
                                workout.workoutActivityType == .walking ?
                                "figure.walk" :
                                "figure.wave"
                        )
                        VStack(alignment: .leading) {
                            Text(workout.workoutActivityType == .walking ? "Walk" : "Run").font(.body)
                            Text(loader.dateFormatter.string(from: workout.startDate)).font(.footnote)
                        }
                        Spacer()
                        Text("\(workout.totalDistance?.doubleValue(for: HKUnit.meterUnit(with: .kilo)) ?? 0) km")
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
