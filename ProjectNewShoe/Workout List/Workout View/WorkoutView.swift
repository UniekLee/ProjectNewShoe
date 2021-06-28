//
//  WorkoutView.swift
//  ProjectNewShoe
//
//  Created by Lee Watkins on 28/06/2021.
//

import SwiftUI

struct WorkoutView: View {
    @ObservedObject var viewModel: WorkoutViewModel

    var body: some View {
        HStack {
            Image(systemName: viewModel.workout.iconName)
            VStack(alignment: .leading) {
                Text(viewModel.workout.name).font(.body)
                Text(viewModel.workout.date).font(.footnote)
            }
            Spacer()
            Text(viewModel.workout.distance)
            viewModel.workout.isIncluded ? Image(systemName: "checkmark.circle.fill") : Image(systemName: "circle")
        }
    }
}

struct WorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutView(
            viewModel: WorkoutViewModel(
                workout: Workout(
                    id: UUID(),
                    iconName: "circle",
                    name: "Run",
                    date: "5 June",
                    distance: "Something",
                    isIncluded: true
                )
            )
        )
    }
}
