//
//  ExercisePickerViewModel.swift
//  Core
//
//  Created by Łukasz Kasperek on 21/11/2021.
//  Copyright © 2021 Łukasz Kasperek. All rights reserved.
//

import Foundation

class ExercisePickerViewModel: ExercisePickerViewModeling {
    @Published private(set) var exercises: [ExerciseCellViewModel] = []
    @Published private(set) var pickedExercises: [ExerciseCellViewModel] = []
    private var pickedIds: [UUID] = []
    private var exerciseModels = [Exercise]()
    
    private let exerciseStorage: ExerciseStoring
    private let pickedRelay: ExercisePickerRelay
    
    init(exerciseStorage: ExerciseStoring, pickedRelay: ExercisePickerRelay) {
        self.exerciseStorage = exerciseStorage
        self.pickedRelay = pickedRelay
    }
    
    func handleViewAppeared() {
        exerciseModels = exerciseStorage.fetchExercises()
        applyCellViewModels()
    }
    
    func pick(_ exercise: ExerciseCellViewModel) {
        pickedIds.append(exercise.id)
        applyCellViewModels()
    }
    
    func remove(_ exercise: ExerciseCellViewModel) {
        pickedIds.removeAll(where: { $0 == exercise.id })
        applyCellViewModels()
    }
    
    private func applyCellViewModels() {
        let mapping: (Exercise) -> ExerciseCellViewModel = { exercise in
            ExerciseCellViewModel(
                id: exercise.id,
                exerciseName: exercise.name
            )
        }
        exercises = exerciseModels
            .filter({ !pickedIds.contains($0.id) })
            .map(mapping)
        pickedExercises = pickedIds
            .map({ id in
                exerciseModels.first(where: { $0.id == id })!
            })
            .map(mapping)
    }
}
