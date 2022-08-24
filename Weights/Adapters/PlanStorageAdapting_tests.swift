//
//  PlanStorageAdapting_tests.swift
//  Weights
//
//  Created by Łukasz Kasperek on 11/08/2022.
//

import Foundation
@testable import Core
import CoreData
import Nimble
@testable import Services
import TestUtilities
import Quick
@testable import Weights

class PlanStorageAdaptingSpec: QuickSpec {
    override func spec() {
        describe("plan repository") {
            var sut: PlanRepository!
            var moContext: NSManagedObjectContext!
            func populateContextWithExercises(from plan: Core.Plan) {
                let allExercises = plan.days
                    .flatMap(\.exercises)
                    .map(\.exercise)
                let exerciseRepository = ExercisesRepository(context: moContext)
                for exercise in allExercises {
                    exerciseRepository.insert(exercise)
                }
            }
            beforeEach {
                NSManagedObjectContext.synchronousMode = true
                moContext = DatabaseStack.testInMemoryContext()
                sut = PlanRepository(context: moContext)
            }
            afterEach {
                sut = nil
                moContext = nil
                NSManagedObjectContext.synchronousMode = false
            }
            describe("when inserting plans") {
                var plansAccumulator: PublisherAccumulator<[Core.Plan], Never>!
                var planToInsert: Core.Plan!
                context("when empty plan inserted") {
                    beforeEach {
                        plansAccumulator = PublisherAccumulator(publisher: sut.autoupdatingPlans)
                        planToInsert = .make()
                        populateContextWithExercises(from: planToInsert!)
                        sut.insert(planToInsert)
                    }
                    it("will emit updated plans") {
                        expect(plansAccumulator.updates.count).to(equal(2))
                        expect(plansAccumulator.update(at: 1)).to(haveCount(1))
                        expect(plansAccumulator.update(at: 1)).to(containElementSatisfying({ insertedPlan in
                            insertedPlan.name == planToInsert.name
                        }))
                    }
                }
                context("when plan with days is inserted") {
                    beforeEach {
                        plansAccumulator = PublisherAccumulator(publisher: sut.autoupdatingPlans)
                        planToInsert = .make(
                            Plan.Proto.Day(
                                .init(.init(1, 3, 10)),
                                .init(.init(2, 3, 10))
                            ),
                            Plan.Proto.Day(
                                .init(.init(1, 3, 10)),
                                .init(.init(2, 3, 10))
                            )
                        )
                        populateContextWithExercises(from: planToInsert!)
                        sut.insert(planToInsert)
                    }
                    it("will emit updated plan") {
                        expect(plansAccumulator.updates.last).to(haveCount(1))
                        expect(plansAccumulator.updates.last).to(containElementSatisfying({ emittedPlan in
                            emittedPlan == planToInsert
                        }))
                    }
                }
            }
        }
    }
}
