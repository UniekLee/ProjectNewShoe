//
//  WorkoutListView.swift
//  ProjectNewShoe
//
//  Created by Lee Watkins on 28/06/2021.
//

import SwiftUI

struct WorkoutListView: View {
    @ObservedObject var viewModel: WorkoutListViewModel

    var body: some View {
        List {
            ForEach(viewModel.workoutViewModels) { workoutVM in
                HStack {
                    Image(systemName: workoutVM.workout.iconName)
                    VStack(alignment: .leading) {
                        Text(workoutVM.workout.name).font(.body)
                        Text(workoutVM.workout.date).font(.footnote)
                    }
                    Spacer()
                    Text(workoutVM.workout.distance)
                    workoutVM.workout.isIncluded ? Image(systemName: "checkmark.circle.fill") : Image(systemName: "circle")
                }
                .onTapGesture {
                    viewModel.toggleInclusion(of: workoutVM.workout)
                }
            }
        }
        .navigationTitle("Project New Shoe")
    }
}

struct WorkoutListView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutListView(viewModel: WorkoutListViewModel(workouts: []))
    }
}
