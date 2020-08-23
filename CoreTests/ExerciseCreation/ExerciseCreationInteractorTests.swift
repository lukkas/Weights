//
//  ExerciseCreationInteractorTests.swift
//  CoreTests
//
//  Created by Łukasz Kasperek on 10/05/2020.
//  Copyright © 2020 Łukasz Kasperek. All rights reserved.
//

@testable import Core
import XCTest

class ExerciseCreationInteractorTests: XCTestCase {
    var sut: ExerciseCreationInteractor!
    var storage: ExerciseStoringStub!

    override func setUpWithError() throws {
        storage = ExerciseStoringStub()
        sut = ExerciseCreationInteractor(exerciseStorage: storage)
    }

    override func tearDownWithError() throws {
        sut = nil
        storage = nil
    }
    
    func test_insertingExercise() {
        // given
        let exercise = Exercise.dummy
        
        // when
        sut.storeExercise(exercise)
        
        // then
        XCTAssertEqual(storage.insertCallsCount, 1)
    }
}
