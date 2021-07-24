import SwiftUI
import ComposableArchitecture

struct Workout: Equatable, Identifiable {
    let id: UUID

    let iconName: String
    let name: String
    let date: String
    let distance: Int

    var isIncluded: Bool
}

enum WorkoutAction {
    case inclusionToggled
}

struct WorkoutEnvironment {}

let workoutReducer = Reducer<Workout, WorkoutAction, WorkoutEnvironment> { state, action, env in
    switch action {
    case .inclusionToggled:
        state.isIncluded.toggle()
        return .none
    }
}

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
