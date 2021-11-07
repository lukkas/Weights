//
//  PlannerExerciseViewModel_tests.swift
//  CoreTests
//
//  Created by Łukasz Kasperek on 07/11/2021.
//  Copyright © 2021 Łukasz Kasperek. All rights reserved.
//

import XCTest
@testable import Core

class PlannerExerciseViewModel_tests: XCTestCase {
    var sut: PlannerExerciseViewModel!
    var exercise: Exercise!
    
    override func setUpWithError() throws {
        exercise = Exercise(
            id: UUID(),
            name: "Squat",
            metric: .reps,
            laterality: .bilateral
        )
        sut = PlannerExerciseViewModel(exercise: exercise)
    }
    
    override func tearDownWithError() throws {
        sut = nil
        exercise = nil
    }
    
    func test_initialVariations() {
        XCTAssertEqual(sut.variations.count, 1)
        XCTAssertEqual(sut.variations.first?.metric, .reps)
        XCTAssertEqual(sut.variations.first?.numerOfSets, 1)
    }
    
    func test_addVariationTapped_shouldAddVariationWithSingleSet() {
        // when
        sut.addVariationTapped()
        
        // then
        XCTAssertEqual(sut.variations.count, 2)
        XCTAssertEqual(sut.variations.first?.numerOfSets, 1)
    }
    
    func test_removingVariation_whenNumerOfSetsIsSetToZero_shouldRemoveVariation() {
        // given
        sut.addVariationTapped()
        let variations = sut.variations
        
        // when
        sut.variations[1].numerOfSets = 0
        
        // then
        XCTAssertEqual(sut.variations, variations.dropLast())
    }
}
