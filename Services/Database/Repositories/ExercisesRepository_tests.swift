//
//  ExercisesRepositoryTests.swift
//  ServicesTests
//
//  Created by Łukasz Kasperek on 03/05/2020.
//  Copyright © 2020 Łukasz Kasperek. All rights reserved.
//

import Combine
import CoreData
import Nimble
@testable import Services
import Quick
import XCTest

class ExerciseRepositorySpec: QuickSpec {
    override func spec() {
        describe("exercise repository") {
            var sut: ExercisesRepository!
            var dateProvider: DateProvider!
            var moContext: NSManagedObjectContext!
            
            beforeEach {
                NSManagedObjectContext.synchronousMode = true
                moContext = NSManagedObjectContext.testInMemoryContext()
                dateProvider = DateProvider()
                sut = ExercisesRepository(
                    context: moContext,
                    currentDate: dateProvider.getDate
                )
            }
            
            afterEach {
                sut = nil
                dateProvider = nil
                moContext = nil
                NSManagedObjectContext.synchronousMode = false
            }
            
            context("given populated db") {
                beforeEach {
                    moContext.populateWithExercises(count: 3)
                }
                
                it("sends current exercises on subscription") {
                    let exercises = try self.awaitPublisher(sut.exercises().prefix(1))
                    expect(exercises).to(haveCount(3))
                }
                
                context("when exercise added") {
                    let id = UUID()
                    let currentDate = Date.stubbed(3, 2, 2022)
                    var accumulator: PublisherAccumulator<[Exercise], Never>!
                    
                    beforeEach {
                        accumulator = PublisherAccumulator(publisher: sut.exercises())
                        dateProvider.currentDate = currentDate
                        sut.insertExercise(
                            id: id,
                            name: "Squat",
                            metric: .reps,
                            laterality: .bilateral
                        )
                    }
                    
                    afterEach {
                        accumulator = nil
                    }
                    
                    it("will emit update") {
                        expect(accumulator.updates).to(haveCount(2))
                        expect(accumulator.update(at: 0)).to(haveCount(3))
                        expect(accumulator.update(at: 1)).to(haveCount(4))
                    }
                }
            }
        }
    }
}

private extension NSManagedObjectContext {
    func populateWithExercises(count: Int) {
        for index in 0 ..< count {
            let exercise = insertObject() as Exercise
            exercise.id = UUID()
            exercise.name = "Exercise \(index)"
            exercise.metric = .reps
            exercise.laterality = .bilateral
            exercise.addedAt = .stubbed(1, 1, 2022)
        }
        performSaveOrRollback()
    }
}

//class ExercisesRepositoryTests: XCTestCase {
//    var sut: ExercisesRepository!
//    var dateProvider: DateProvider!
//
//    override func setUpWithError() throws {
//        NSManagedObjectContext.synchronousMode = true
//        let container = try awaitValue(makeInMemoryPeristentContainer())
//        dateProvider = DateProvider()
//        sut = ExercisesRepository(
//            context: container.viewContext,
//            notificationCenter: <#T##NotificationCenter#>
//            currentDate: dateProvider.getDate
//        )
//    }
//
//    override func tearDownWithError() throws {
//        sut = nil
//        dateProvider = nil
//        NSManagedObjectContext.synchronousMode = true
//    }
//
//    func test_addingExercise_whenRetrieved_shouldBeSameAsAdded() {
//        // given
//        let id = UUID()
//        let currentDate = Date()
//        dateProvider.currentDate = currentDate
//        // when
//
//        sut.insertExercise(
//            id: id,
//            name: "Squat",
//            metric: .reps,
//            laterality: .bilateral
//        )
//
//        // then
//        let result = sut.fetchExercises()
//        result.verify_hasOneExercise(
//            withId: id,
//            name: "Squat",
//            metric: .reps,
//            laterlaity: .bilateral,
//            addedAt: currentDate
//        )
//    }
//
//    func test_exercisesSubscription_shouldReturnAllExercisesAfterSubscription() {
//
//    }
//}

private extension Array where Element == Exercise {
    func verify_hasOneExercise(
        withId id: UUID,
        name: String,
        metric: Exercise.Metric,
        laterlaity: Exercise.Laterality,
        addedAt: Date,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        XCTAssertEqual(count, 1, file: file, line: line)
        let exercise = self[0]
        XCTAssertEqual(exercise.id, id, file: file, line: line)
        XCTAssertEqual(exercise.name, name, file: file, line: line)
        XCTAssertEqual(exercise.metric, metric, file: file, line: line)
        XCTAssertEqual(exercise.laterality, laterlaity, file: file, line: line)
        XCTAssertEqual(exercise.addedAt, addedAt, file: file, line: line)
    }
}
