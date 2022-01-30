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
                    let exerciseName = "Squat"
                    let currentDate = Date.stubbed(3, 2, 2022)
                    var accumulator: PublisherAccumulator<[Exercise], Never>!
                    
                    beforeEach {
                        accumulator = PublisherAccumulator(publisher: sut.exercises())
                        dateProvider.currentDate = currentDate
                        sut.insertExercise(
                            id: id,
                            name: exerciseName,
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
                    
                    it("will contain added exercies") {
                        let predicate: (Exercise) -> Bool = {
                            return $0.id == id
                            && $0.addedAt == currentDate
                            && $0.name == exerciseName
                        }
                        expect(accumulator.update(at: 0)).toNot(containElementSatisfying(predicate))
                        expect(accumulator.update(at: 1)).to(containElementSatisfying(predicate))
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
