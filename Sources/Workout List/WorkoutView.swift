import SwiftUI
import ComposableArchitecture

public struct WorkoutState: Equatable, Identifiable {
    public let id: UUID

    public let iconName: String
    public let name: String
    public let date: Date
    public let time: String
    public let distance: Int

    public var isIncluded: Bool
}

enum WorkoutAction {
    case workoutTapped
    case inclusionToggled(isIncluded: Bool)
}

public struct WorkoutEnvironment {
    let toggleSelection: ((_ workout: WorkoutState) -> Effect<Bool, Never>)
}

let workoutReducer = Reducer<WorkoutState, WorkoutAction, WorkoutEnvironment> { state, action, env in
    switch action {
    case .workoutTapped:
        return env.toggleSelection(state).map(WorkoutAction.inclusionToggled(isIncluded:))
    case .inclusionToggled(let isIncluded):
        state.isIncluded = isIncluded
        return .none
    }
}

struct WorkoutView: View {
    let store: Store<WorkoutState, WorkoutAction>

    var body: some View {
        WithViewStore(store) { viewStore in
            HStack {
                Text(viewStore.iconName)
                VStack(alignment: .leading) {
                    Text(viewStore.name).font(.body)
                    Text(viewStore.time).font(.footnote)
                }
                Spacer()
                Text("\(viewStore.distance.asRoundedKM, specifier: "%.2f") km")
                Image(systemName: viewStore.isIncluded ? "checkmark.circle.fill" : "circle")
            }
            .onTapGesture {
                viewStore.send(.workoutTapped)
            }
        }
    }
}

struct WorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutView(
            store: Store(
                initialState: WorkoutState.mockWorkouts.first!,
                reducer: workoutReducer,
                environment: WorkoutEnvironment(
                    toggleSelection: { _ in return Effect(value: true) }
                )
            )
        )
    }
}
