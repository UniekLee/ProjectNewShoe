import ComposableArchitecture
import SwiftUI

struct DateSectionState: Equatable, Identifiable {
    let id: UUID = UUID()
    let date: Date
    var workouts: [Workout]
}

enum DateSectionAction {
    case workout(index: Int, action: WorkoutAction)
}

struct DateSectionEnvironment {}

let dateSectionReducer: Reducer<DateSectionState, DateSectionAction, DateSectionEnvironment> = .combine([
    workoutReducer.forEach(
        state: \DateSectionState.workouts,
        action: /DateSectionAction.workout(index:action:),
        environment: { _ in
            WorkoutEnvironment(
                toggleSelection: { workout in
                    let isIncluded = Persistence.shared.toggle(workout: workout)
                    return Effect(value: isIncluded)
                }
            )
        }
    )
])

struct DateSectionView: View {
    let store: Store<DateSectionState, DateSectionAction>
    var body: some View {
        WithViewStore(self.store) { viewStore in
            Section(
                header: Text(Formatter.date.string(from: viewStore.state.date))
            ) {
                ForEachStore(
                    self.store.scope(
                        state: \.workouts,
                        action: DateSectionAction.workout(index:action:)
                    ),
                    content: WorkoutView.init(store:)
                )
            }
        }
    }
}

struct DateSectionView_Previews: PreviewProvider {
    static var previews: some View {
        DateSectionView(
            store: Store(
                initialState: DateSectionState(
                    date: Date(),
                    workouts: Workout.mockWorkouts
                ),
                reducer: dateSectionReducer,
                environment: DateSectionEnvironment()
            )
        )
    }
}
