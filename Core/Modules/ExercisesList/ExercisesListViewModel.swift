//
//  ExercisesListViewModel.swift
//  Core
//
//  Created by Łukasz Kasperek on 17/05/2020.
//  Copyright © 2020 Łukasz Kasperek. All rights reserved.
//

import Combine
import Foundation
import SwiftUI

class ExercisesListViewModel: ExerciseListViewModeling {
    @Published private(set) var cellViewModels: [ExerciseCellViewModel] = []
    private let exerciseStorage: ExerciseStoring
    private var cancellables: Set<AnyCancellable> = []
    
    init(exerciseStorage: ExerciseStoring) {
        self.exerciseStorage = exerciseStorage
        subscribeToExercises()
    }
    
    private func subscribeToExercises() {
        exerciseStorage.autoupdatingExercises()
            .map { exercises in
                exercises.map({ exercise in
                    ExerciseCellViewModel(
                        id: exercise.id,
                        exerciseName: exercise.name
                    )
                })
            }
            .sink(receiveValue: { [weak self] viewModels in
                self?.cellViewModels = viewModels
            })
            .store(in: &cancellables)
    }
}
