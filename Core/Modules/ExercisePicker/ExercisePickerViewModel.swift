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
    @Published var selection: Set<ExerciseCellViewModel> = [] {
        didSet {
            
        }
    }
    
    private let exerciseStorage: ExerciseStoring
    
    init(exerciseStorage: ExerciseStoring) {
        self.exerciseStorage = exerciseStorage
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
        
    }
}
