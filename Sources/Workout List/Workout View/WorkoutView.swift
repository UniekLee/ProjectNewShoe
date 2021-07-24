import SwiftUI

struct WorkoutView: View {
    @ObservedObject var viewModel: WorkoutViewModel

    var body: some View {
        HStack {
            Text(viewModel.workout.iconName)
            VStack(alignment: .leading) {
                Text(viewModel.workout.name).font(.body)
                Text(viewModel.workout.date).font(.footnote)
            }
            Spacer()
            Text(viewModel.distance)
            Image(systemName: viewModel.inclusionStateIconName)
                .onTapGesture {
                    self.viewModel.toggleInclusion()
                }
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
                    distance: 1234,
                    isIncluded: true
                )
            )
        )
    }
}
