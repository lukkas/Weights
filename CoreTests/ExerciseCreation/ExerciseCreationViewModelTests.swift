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
        sut.name = "Squat"
        sut.metric = .reps
        sut.laterality = .bilateral
        
        // then
        XCTAssertTrue(sut.isAddButtonActive)
    }
}
