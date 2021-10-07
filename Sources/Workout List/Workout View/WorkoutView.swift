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
        // TODO: Figure out how to persist this
        return .none
    }
}

struct WorkoutView: View {
    let store: Store<Workout, WorkoutAction>

    var body: some View {
        WithViewStore(store) { viewStore in
            HStack {
                Text(viewStore.iconName)
                VStack(alignment: .leading) {
                    Text(viewStore.name).font(.body)
                    Text(viewStore.date).font(.footnote)
                }
                Spacer()
                Text("\(viewStore.distance.asRoundedKM) km")
                Image(systemName: viewStore.isIncluded ? "checkmark.circle.fill" : "circle")
            }
            .onTapGesture {
                viewStore.send(.inclusionToggled)
            }
        }
    }
}

struct WorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutView(
            store: Store(
                initialState: Workout(
                    id: UUID(),
                    iconName: "🏃🏻‍♂️💨",
                    name: "Run",
                    date: "5 June",
                    distance: 1234,
                    isIncluded: true
                ),
                reducer: workoutReducer,
                environment: WorkoutEnvironment())
        )
    }
}
