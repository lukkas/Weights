//
//  ExerciseStoringStub.swift
//  CoreTests
//
//  Created by Łukasz Kasperek on 10/05/2020.
//  Copyright © 2020 Łukasz Kasperek. All rights reserved.
//

import Combine
@testable import Core
import Foundation
import XCTest

class ExerciseStoringStub: ExerciseStoring {
    private let exercisesSubject = CurrentValueSubject<[Exercise], Never>([])
    
    var insertCallsCount: Int { insertedExercises.count }
    private var insertedExercises: [Exercise] = []
    func insert(_ exercise: Exercise) {
        insertedExercises.append(exercise)
        exercisesSubject.value.append(exercise)
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
    
    func autoupdatingExercises() -> AnyPublisher<[Exercise], Never> {
        return exercisesSubject.eraseToAnyPublisher()
    }
    
    func preconfigure_populate(with exercises: [Exercise]) {
        exercisesSubject.value = exercises
    }
}
