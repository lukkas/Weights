//
//  ExercisePickerViewModel_tests.swift
//  CoreTests
//
//  Created by Łukasz Kasperek on 21/11/2021.
//  Copyright © 2021 Łukasz Kasperek. All rights reserved.
//

import XCTest
@testable import Core

class ExercisePickerViewModel_tests: XCTestCase {
    var sut: ExercisePickerViewModel!
    var exerciseStorage: ExerciseStoringStub!

    override func setUpWithError() throws {
        exerciseStorage = ExerciseStoringStub()
        sut = ExercisePickerViewModel(exerciseStorage: exerciseStorage)
    }

    override func tearDownWithError() throws {
        sut = nil
        exerciseStorage = nil
    }
    
    func test_populatingWithData() {
        // given
        let exercises = Exercise.make(count: 3)
        exerciseStorage.preconfigure_populate(with: exercises)
        
        // when
        sut.handleViewAppeared()
        
        // then
        XCTAssertMatches(exercises, sut.exercises) { exercise, cellViewModel in
            XCTAssertEqual(exercise.name, cellViewModel.exerciseName)
        }
    }
    
    
}
