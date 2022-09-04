//
//  PlannerPageViewModel.swift
//  Core
//
//  Created by Łukasz Kasperek on 16/06/2022.
//

import Foundation

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
