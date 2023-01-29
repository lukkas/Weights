//
//  PlannerPageView.swift
//  Core
//
//  Created by Łukasz Kasperek on 17/04/2022.
//

import SwiftUI

struct PlannerPageView: View {
    enum Action {
        case addExercise
        case addSet(PlannerExercise)
        case removeSet(PlannerExercise.Set, PlannerExercise)
        case addToSupeset(PlannerExercise)
        case removeFromSuperset(PlannerExercise)
    }
    
    @Binding var model: PlannerPage
    @Binding var currentlyDragged: PlannerExercise?
    @Binding var allPages: [PlannerPage]
    let onAction: (Action) -> Void
    
    var body: some View {
        ScrollView {
            Color.clear
            LazyVStack(spacing: 0) {
                ForEach(model.exercises) { exercise in
                    let isFirst = model.exercises.first == exercise
                    let isLast = model.exercises.last == exercise
                    exerciseView(
                        Binding(
                            get: { model.exercises.first(matchingIdOf: exercise)! },
                            set: { exercise in
                                let index = model.exercises.firstIndex(matchingIdOf: exercise)!
                                model.exercises[index] = exercise
                            }
                        ),
                        isFirst: isFirst,
                        isLast: isLast
                    )
                    if !isLast {
                        ExerciseSupersetConnectionView {
                            
                        }
                    }
                }
                Color.clear
                addExerciseButton()
                if model.exercises.isEmpty {
                    emptyDropArea()
                }
            }
            Color.clear
        }
    }
    
    private func exerciseView(
        _ exercise: Binding<PlannerExercise>,
        isFirst: Bool,
        isLast: Bool
    ) -> some View {
        func edges() -> Edge.Set {
            var edges = [] as Edge.Set
            if !isFirst {
                edges.insert(.top)
            }
            if !isLast {
                edges.insert(.bottom)
            }
            return edges
        }
        return PlannerExerciseView(
            model: exercise,
            isAddToSupersetDisabled: true,
            isRemoveFromSupersetDisabled: true,
            onAction: { action in
                switch action {
                case .addSet:
                    onAction(.addSet(exercise.wrappedValue))
                case let .removeSet(set):
                    onAction(.removeSet(set, exercise.wrappedValue))
                case .addToSuperset:
                    onAction(.addToSupeset(exercise.wrappedValue))
                case .removeFromSuperset:
                    onAction(.removeFromSuperset(exercise.wrappedValue))
                }
            }
        )
        .linkedCardDesign(edges: edges())
        .onDrag({
            currentlyDragged = exercise.wrappedValue
            return PlannerExerciseDraggable.itemProvider
        })
        .onDrop(
            of: [PlannerExerciseDraggable.uti],
            delegate: PlannerDropController(
                target: .exercise(exercise.wrappedValue),
                currentlyDragged: $currentlyDragged,
                pages: $allPages
            )
        )
        .padding(.horizontal, 16)
    }
    
    @ViewBuilder private func addExerciseButton() -> some View {
        Button {
            onAction(.addExercise)
        } label: {
            Text(L10n.Planner.addExercise)
                .textStyle(.largeButton)
                .frame(maxWidth: .infinity, minHeight: 32)
        }
        .buttonStyle(.bordered)
        .padding(.horizontal, 16)
    }
    
    @ViewBuilder private func emptyDropArea() -> some View {
        Color.clear
            .contentShape(Rectangle())
            .frame(maxWidth: .infinity, minHeight: 300)
            .onDrop(
                of: [PlannerExerciseDraggable.uti],
                delegate: PlannerDropController(
                    target: .emptyPage(model),
                    currentlyDragged: $currentlyDragged,
                    pages: $allPages
                )
            )
    }
}

// MARK: - Design time

#if DEBUG
struct PlannerPageView_Previews: PreviewProvider {
    struct Wrapper: View {
        @State var page = PlannerPage(
            id: UUID(),
            name: "A1",
            exercises: [
                .dt_squat(),
                .dt_deadlift(),
                .dt_squat(supersets: true),
                .dt_squat(supersets: true)
            ]
        )
        
        var body: some View {
            PlannerPageView(
                model: $page,
                currentlyDragged: .constant(nil),
                allPages: .constant([]),
                onAction: { _ in }
            )
        }
    }
    
    static var previews: some View {
        Wrapper()
            .cellPreview()
    }
}
#endif
