//
//  PlannerPageView.swift
//  Core
//
//  Created by Łukasz Kasperek on 17/04/2022.
//

import SwiftUI

struct PlannerPageView<ExerciseViewModel: PlannerExerciseViewModeling>: View {
    @ObservedObject var model: PlannerPageViewModel<ExerciseViewModel>
    @Binding var currentlyDragged: ExerciseViewModel?
    @Binding var allPages: [PlannerPageViewModel<ExerciseViewModel>]
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
    
    @ViewBuilder private func exerciseView(_ exercise: ExerciseViewModel) -> some View {
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
                .font(.system(
                    size: 18,
                    weight: .medium,
                    design: .rounded
                ))
                .frame(maxWidth: .infinity, minHeight: 44)
        }
        .buttonStyle(.borderedProminent)
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

class PlannerPageViewModel<ExerciseModel: PlannerExerciseViewModeling>: ObservableObject, Identifiable, Hashable {
    let id = UUID()
    var name: String
    @Published private(set) var exercises: [ExerciseModel]
    
    init(name: String, exercises: [ExerciseModel] = []) {
        self.name = name
        self.exercises = exercises
    }
    
    func addExercises(_ models: [ExerciseModel]) {
        exercises.append(contentsOf: models)
    }
    
    func removeExercise(at index: Int) {
        exercises.remove(at: index)
    }
    
    func insertExercise(_ exercise: ExerciseModel, at index: Int) {
        exercises.insert(exercise, at: index)
    }
    
    func move(fromOffsets offsets: IndexSet, to offset: Int) {
        exercises.move(fromOffsets: offsets, toOffset: offset)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(exercises)
    }
    
    static func == (
        lhs: PlannerPageViewModel<ExerciseModel>,
        rhs: PlannerPageViewModel<ExerciseModel>
    ) -> Bool {
        return lhs.id == rhs.id
        && lhs.name == rhs.name
        && lhs.exercises == rhs.exercises
    }
}
