//
//  ExerciseStoringStub.swift
//  CoreTests
//
//  Created by Łukasz Kasperek on 10/05/2020.
//  Copyright © 2020 Łukasz Kasperek. All rights reserved.
//

@testable import Core
import Foundation
import XCTest

class ExerciseStoringStub: ExerciseStoring {
    private var exercises: [Exercise] = []
    
    var insertCallsCount: Int { insertedExercises.count }
    private var insertedExercises: [Exercise] = []
    func insert(_ exercise: Exercise) {
        insertedExercises.append(exercise)
        exercises.append(exercise)
    }
    
    func verify_insertedExercise(
        at index: Int,
        asserts: (Exercise) -> Void
    ) {
        guard insertedExercises.count > index else {
            XCTFail("Expected exercise at index \(index), but got only \(insertedExercises.count)")
            return
        }
        asserts(insertedExercises[index])
    }
    
    func fetchExercises() -> [Exercise] {
        return exercises
    }
    
    func preconfigure_populate(with exercises: [Exercise]) {
        self.exercises = exercises
    }
}
