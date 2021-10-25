import ComposableArchitecture
import SwiftUI

struct WorkoutsListState: Equatable {
    var totalDistanceOfIncludedWorkouts: Int = 0
    var dateSections: [DateSectionState] = []
}

enum WorkoutsListAction {
    case section(index: Int, action: DateSectionAction)
}

struct WorkoutsListEnvironment {
    
}

let workoutsListReducer: Reducer<WorkoutsListState, WorkoutsListAction, WorkoutsListEnvironment> = .combine(
    [
        dateSectionReducer.forEach(
            state: \WorkoutsListState.dateSections,
            action: /WorkoutsListAction.section(index:action:),
            environment: { _ in DateSectionEnvironment() }
        ),
        Reducer { state, action, environment in
            switch action {
            case .section:
                state.totalDistanceOfIncludedWorkouts = state.dateSections
                    .flatMap(\.workouts)
                    .filter({ $0.isIncluded })
                    .reduce(0, { $0 + $1.distance })
                return .none
            }
        }
    ]
)

struct WorkoutsList: View {
    let store: Store<WorkoutsListState, WorkoutsListAction>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            HStack {
                Text("Total distance")
                Spacer()
                Text("\(viewStore.totalDistanceOfIncludedWorkouts.asRoundedKM, specifier: "%.2f") km / 800 km")
            }.padding()
            List {
                ForEachStore(
                    self.store.scope(
                        state: \.dateSections,
                        action: WorkoutsListAction.section(index:action:)
                    ),
                    content: DateSectionView.init(store:)
                )
            }.listStyle(InsetGroupedListStyle())
        }
    }
}

struct WorkoutsList_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutsList(
            store: Store(
                initialState: WorkoutsListState(
                    totalDistanceOfIncludedWorkouts: 0,
                    dateSections: [
                        DateSectionState(
                            date: Date(),
                            workouts: WorkoutState.mockWorkouts
                        )
                    ]
                ),
                reducer: workoutsListReducer,
                environment: WorkoutsListEnvironment()
            )
        )
    }
}
