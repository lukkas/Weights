//
//  ExercisesListViewModel.swift
//  Core
//
//  Created by Łukasz Kasperek on 17/05/2020.
//  Copyright © 2020 Łukasz Kasperek. All rights reserved.
//

import Foundation
import SwiftUI

protocol ExerciseListViewModeling: ObservableObject {
    var routes: ExercisesListViewModel.Routes { get }
    var cellViewModels: [ExerciseCellViewModel] { get }
}

class ExercisesListViewModel: ExerciseListViewModeling {
    struct Routes {
        let createExercise: () -> ExerciseCreationViewModel
    }
    
    let routes: Routes
    @Published private(set) var cellViewModels: [ExerciseCellViewModel] = []
    private let exerciseStorage: ExerciseStoring
    
    init(exerciseStorage: ExerciseStoring, routes: Routes) {
        self.exerciseStorage = exerciseStorage
        self.routes = routes
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
