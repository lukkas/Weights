//
//  ExerciseStoring.swift
//  Core
//
//  Created by Łukasz Kasperek on 03/05/2020.
//  Copyright © 2020 Łukasz Kasperek. All rights reserved.
//

import Foundation

public protocol ExerciseStoring {
    func insert(_ exercise: Exercise)
    func fetchExercises() -> [Exercise]
}

#if DEBUG
class PlaceholderExerciseStorage: ExerciseStoring {
    var exercises = [Exercise]()
    
    func insert(_ exercise: Exercise) {
        exercises.append(exercise)
    }
    
    func fetchExercises() -> [Exercise] {
        return exercises
    }
}
#endif
