//
//  ExercisesRepositoryTests.swift
//  ServicesTests
//
//  Created by Łukasz Kasperek on 03/05/2020.
//  Copyright © 2020 Łukasz Kasperek. All rights reserved.
//

import Combine
import CoreData
@testable import Services
import XCTest

class ExercisesRepositoryTests: XCTestCase {
    var sut: ExercisesRepository!
    var dateProvider: DateProvider!

    override func setUpWithError() throws {
        NSManagedObjectContext.synchronousMode = true
        let container = try awaitValue(makeInMemoryPeristentContainer())
        dateProvider = DateProvider()
        sut = ExercisesRepository(
            context: container.viewContext,
            currentDate: dateProvider.getDate
        )
    }

    override func tearDownWithError() throws {
        sut = nil
        dateProvider = nil
    }
    
    func test_addingExercise_whenRetrieved_shouldBeSameAsAdded() {
        // given
        let id = UUID()
        let currentDate = Date()
        dateProvider.currentDate = currentDate
        // when
        
        sut.insertExercise(
            id: id,
            name: "Squat",
            volumeUnit: .reps,
            laterality: .bilateral
        )
        
        // then
        let result = sut.fetchExercises()
        result.verify_hasOneExercise(
            withId: id,
            name: "Squat",
            volumeUnit: .reps,
            laterlaity: .bilateral,
            addedAt: currentDate
        )
    }
}

private extension Array where Element == Exercise {
    func verify_hasOneExercise(
        withId id: UUID,
        name: String,
        volumeUnit: Exercise.VolumeUnit,
        laterlaity: Exercise.Laterality,
        addedAt: Date,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        XCTAssertEqual(count, 1, file: file, line: line)
        let exercise = self[0]
        XCTAssertEqual(exercise.id, id, file: file, line: line)
        XCTAssertEqual(exercise.name, name, file: file, line: line)
        XCTAssertEqual(exercise.volumeUnit, volumeUnit, file: file, line: line)
        XCTAssertEqual(exercise.laterality, laterlaity, file: file, line: line)
        XCTAssertEqual(exercise.addedAt, addedAt, file: file, line: line)
    }
}
