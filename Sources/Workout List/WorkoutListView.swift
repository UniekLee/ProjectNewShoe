import SwiftUI

struct WorkoutListView: View {
    @ObservedObject var viewModel: WorkoutListViewModel

    var body: some View {
        VStack {
            HStack {
                Text("Total distance")
                Spacer()
                Text("\(viewModel.totalDistance.asRoundedKM, specifier: "%.2f") km")
            }
            .padding()
            List {
                ForEach(viewModel.workoutViewModels) { workoutVM in
                    WorkoutView(
                        viewModel: WorkoutViewModel(workout: workoutVM.workout)
                    )
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
