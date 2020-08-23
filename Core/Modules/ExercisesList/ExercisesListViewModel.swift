//
//  ExercisesListViewModel.swift
//  Core
//
//  Created by Łukasz Kasperek on 17/05/2020.
//  Copyright © 2020 Łukasz Kasperek. All rights reserved.
//

import Foundation
import SwiftUI

class ExercisesListViewModel: ObservableObject {
    struct Routes {
        let createExercise: () -> ExerciseCreationViewModel
    }
    
    let routes: Routes
    private let exerciseStorage: ExerciseStoring
    
    init(exerciseStorage: ExerciseStoring, routes: Routes) {
        self.exerciseStorage = exerciseStorage
        self.routes = routes
    }
}
