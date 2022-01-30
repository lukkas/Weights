//
//  ExerciseStoring.swift
//  Core
//
//  Created by Łukasz Kasperek on 03/05/2020.
//  Copyright © 2020 Łukasz Kasperek. All rights reserved.
//

import Combine
import Foundation

public protocol ExerciseStoring {
    func insert(_ exercise: Exercise)
    func exercises() -> AnyPublisher<[Exercise], Never>
}

#if DEBUG
class PlaceholderExerciseStorage: ExerciseStoring {
    var storedExercises = [Exercise]()
    
    func insert(_ exercise: Exercise) {
        storedExercises.append(exercise)
    }
    
    func exercises() -> AnyPublisher<[Exercise], Never> {
        return Just(storedExercises).eraseToAnyPublisher()
    }
}
#endif
