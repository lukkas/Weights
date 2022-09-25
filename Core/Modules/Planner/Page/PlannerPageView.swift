//
//  PlannerPageView.swift
//  Core
//
//  Created by Łukasz Kasperek on 17/04/2022.
//

import SwiftUI

struct PlannerPageView: View {
    @ObservedObject var model: PlannerPageViewModel
    @Binding var currentlyDragged: PlannerExerciseViewModel?
    @Binding var allPages: [PlannerPageViewModel]
    let addExerciseTapped: () -> Void
    
    var body: some View {
        ScrollView {
            Color.clear
            LazyVStack(spacing: 16) {
                ForEach(model.exercises) { exercise in
                    exerciseView(exercise)
                }
                addExerciseButton()
                if model.exercises.isEmpty {
                    emptyDropArea()
                }
            }
            Color.clear
        }
    }
    
    @ViewBuilder private func exerciseView(_ exercise: PlannerExerciseViewModel) -> some View {
        PlannerExerciseView(model: exercise)
            .onDrag({
                currentlyDragged = exercise
                return PlannerExerciseDraggable.itemProvider
            })
            .onDrop(
                of: [PlannerExerciseDraggable.uti],
                delegate: PlannerDropController(
                    target: .exercise(exercise),
                    currentlyDragged: $currentlyDragged,
                    pages: $allPages
                )
            )
            .padding(.horizontal, 16)
    }
    
    @ViewBuilder private func addExerciseButton() -> some View {
        Button {
            addExerciseTapped()
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

struct PlannerPageView_Previews: PreviewProvider {
    static var previews: some View {
        PlannerPageView(
            model: PlannerPageViewModel(name: "A1", exercises: [PlannerExerciseViewModel.dt_squat]),
            currentlyDragged: .constant(nil),
            allPages: .constant([]),
            addExerciseTapped: {}
        )
        .cellPreview()
    }
}
