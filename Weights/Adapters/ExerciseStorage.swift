//
//  ExerciseStorage.swift
//  Weights
//
//  Created by Łukasz Kasperek on 18/05/2020.
//  Copyright © 2020 Łukasz Kasperek. All rights reserved.
//

import Combine
import Core
import Foundation
import Services

extension ExercisesRepository: ExerciseStoring {
    public func insert(_ exercise: Core.Exercise) {
        insertExercise(
            id: exercise.id,
            name: exercise.name,
            metric: exercise.metric.toServices(),
            laterality: exercise.laterality.toServices()
        )
    }
    
    public func exercises() -> AnyPublisher<[Core.Exercise], Never> {
        return self.exercises()
            .map({ $0.map({ $0.toCore() }) })
            .eraseToAnyPublisher()
    }
}


