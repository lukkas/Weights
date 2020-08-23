//
//  ExerciseStorage.swift
//  Weights
//
//  Created by Łukasz Kasperek on 18/05/2020.
//  Copyright © 2020 Łukasz Kasperek. All rights reserved.
//

import Core
import Foundation
import Services

extension ExercisesRepository: ExerciseStoring {
    public func insert(_ exercise: Core.Exercise) {
        insertExercise(
            id: exercise.id,
            name: exercise.name,
            volumeUnit: exercise.volumeUnit.toServices(),
            laterality: exercise.laterality.toServices()
        )
    }
    
    public func fetchExercises() -> [Core.Exercise] {
        return self.fetchExercises()
            .map({ $0.toCore() })
    }
}


