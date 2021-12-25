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
    
    private let exerciseStorage: ExerciseStoring
    private let pickedRelay: ExercisePickerRelay
    
    init(exerciseStorage: ExerciseStoring, pickedRelay: ExercisePickerRelay) {
        self.exerciseStorage = exerciseStorage
        self.pickedRelay = pickedRelay
    }
    
    func handleViewAppeared() {
        exercises = exerciseStorage.fetchExercises()
            .map({ exercise in
                ExerciseCellViewModel(
                    id: exercise.id,
                    exerciseName: exercise.name
                )
            })
    }
    
    func pick(_ exercise: ExerciseCellViewModel) {
        exercises.removeAll(where: { $0.id == exercise.id })
    }
    
    func remove(_ exercise: ExerciseCellViewModel) {
        
    }
}
