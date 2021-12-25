//
//  ExercisePickerViewModel_tests.swift
//  CoreTests
//
//  Created by Łukasz Kasperek on 21/11/2021.
//  Copyright © 2021 Łukasz Kasperek. All rights reserved.
//

import XCTest
@testable import Core
import Nimble

class ExercisePickerViewModel_tests: XCTestCase {
    var sut: ExercisePickerViewModel!
    var exerciseStorage: ExerciseStoringStub!
    var exercises: [Exercise]!

    override func setUpWithError() throws {
        exerciseStorage = ExerciseStoringStub()
        let pickerRelay = ExercisePickerRelay(onPicked: { _ in })
        sut = ExercisePickerViewModel(
            exerciseStorage: exerciseStorage,
            pickedRelay: pickerRelay
        )
    }

    override func tearDownWithError() throws {
        sut = nil
        exerciseStorage = nil
        exercises = nil
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
    
    func test_exercisePicked_shouldPopulatePickedExercisesArray() {
        // given
        let exercises = Exercise.make(count: 3)
        exerciseStorage.preconfigure_populate(with: exercises)
        sut.handleViewAppeared()
        
        // when
        expect(2).to(equal(2))
//        let cellViewModel = ExerciseCellViewModel(id: <#T##UUID#>, exerciseName: <#T##String#>)
//        sut.pick(<#T##exercise: ExerciseCellViewModel##ExerciseCellViewModel#>)
    }
    
//    private func
}
