//
//  ExerciseCreationViewModelTests.swift
//  CoreTests
//
//  Created by Łukasz Kasperek on 13/09/2020.
//  Copyright © 2020 Łukasz Kasperek. All rights reserved.
//

@testable import Core
import XCTest

class ExerciseCreationViewModelTests: XCTestCase {
    var sut: ExerciseCreationViewModel!
    var exerciseStorage: ExerciseStoringStub!
    
    override func setUpWithError() throws {
        exerciseStorage = ExerciseStoringStub()
        sut = ExerciseCreationViewModel(exerciseStorage: exerciseStorage)
    }

    override func tearDownWithError() throws {
        exerciseStorage = nil
        sut = nil
    }
    
    func test_isAddButtonActive_whenNothingFilled_shouldBeFalse() {
        XCTAssertFalse(sut.isAddButtonActive)
    }
    
    func test_isAddButtonActive_whenOnlyMetricAndLateralityFilled_shouldBeFalse() {
        // when
        sut.metric = .duration
        sut.laterality = .unilateralIndividual
        
        // then
        XCTAssertFalse(sut.isAddButtonActive)
    }
    
    func test_isAddButtonActive_whenTitleFilled_shouldBeFalse() {
        // when
        sut.name = "Squat"
        
        // then
        XCTAssertFalse(sut.isAddButtonActive)
    }
    
    func test_isAddButtonActive_whenEverythingFilled_shouldBeTrue() {
        // when
        preconfigure_sutFilledWithCorrectData()
        
        // then
        XCTAssertTrue(sut.isAddButtonActive)
    }
    
    func test_add_whenDataIncomplete_shouldNotAddExercise() {
        // when
        sut.handleAddTapped()
        
        // then
        XCTAssertEqual(exerciseStorage.insertCallsCount, 0)
    }
    
    func test_add_whenDataISFilled_shouldInsertExercise() {
        // given
        preconfigure_sutFilledWithCorrectData()
        
        // when
        sut.handleAddTapped()
        
        // then
        exerciseStorage.verify_insertedExercise(at: 0) { received in
            XCTAssertEqual(received.name, sut.name)
            XCTAssertEqual(received.metric, sut.metric)
            XCTAssertEqual(received.laterality, sut.laterality)
        }
    }
    
    func test_add_whenAdded_shouldEmitFromDidAddExercisePublisher() {
        // given
        let listener = PublisherListener(publisher: sut.didAddExercise)
        preconfigure_sutFilledWithCorrectData()
        
        // when
        sut.handleAddTapped()
        
        // then
        XCTAssertEqual(listener.receivedValues.count, 1)
    }
    
    private func preconfigure_sutFilledWithCorrectData() {
        sut.name = "Deadlift"
        sut.metric = .reps
        sut.laterality = .bilateral
    }
}
