//
//  ExercisesListViewModel.swift
//  Core
//
//  Created by Łukasz Kasperek on 17/05/2020.
//  Copyright © 2020 Łukasz Kasperek. All rights reserved.
//

import Foundation
import SwiftUI

class ExercisesListViewModel: ExerciseListViewModeling {
    @Published private(set) var cellViewModels: [ExerciseCellViewModel] = []
    private let exerciseStorage: ExerciseStoring
    
    init(exerciseStorage: ExerciseStoring) {
        self.exerciseStorage = exerciseStorage
        loadContent()
    }
    
    private func loadContent() {
        cellViewModels = exerciseStorage.fetchExercises()
            .map({ exercise in
                ExerciseCellViewModel(
                    id: exercise.id,
                    exerciseName: exercise.name
                )
            })
    }
}
