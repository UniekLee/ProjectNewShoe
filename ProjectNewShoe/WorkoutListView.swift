//
//  WorkoutListView.swift
//  ProjectNewShoe
//
//  Created by Lee Watkins on 28/06/2021.
//

import SwiftUI

struct WorkoutListView: View {
    @ObservedObject var loader: WorkoutLoader

    var body: some View {
        List {
            ForEach(loader.workouts) { workout in
                HStack {
                    Image(systemName: workout.iconName)
                    VStack(alignment: .leading) {
                        Text(workout.name).font(.body)
                        Text(workout.date).font(.footnote)
                    }
                    Spacer()
                    Text(workout.distance)
                    workout.isIncluded ? Image(systemName: "checkmark.circle.fill") : Image(systemName: "circle")
                }
                .onTapGesture {
                    loader.toggleInclusion(of: workout)
                }
            }
        }
        .navigationTitle("Project New Shoe")
    }
}

struct WorkoutListView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutListView(loader: WorkoutLoader())
    }
}
