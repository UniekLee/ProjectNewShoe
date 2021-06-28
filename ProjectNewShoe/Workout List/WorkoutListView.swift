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
                WorkoutView(
                    viewModel: WorkoutViewModel(workout: workoutVM.workout)
                ).onTapGesture {
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
