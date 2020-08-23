//
//  ExerciseStoringStub.swift
//  CoreTests
//
//  Created by Łukasz Kasperek on 10/05/2020.
//  Copyright © 2020 Łukasz Kasperek. All rights reserved.
//

@testable import Core
import Foundation

class ExerciseStoringStub: ExerciseStoring {
    var insertCallsCount = 0
    func insert(_ exercise: Exercise) {
        insertCallsCount += 1
    }
    
    func fetchExercises() -> [Exercise] {
        return []
    }
}
