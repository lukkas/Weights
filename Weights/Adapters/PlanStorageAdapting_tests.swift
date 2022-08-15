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
            beforeEach {
                NSManagedObjectContext.synchronousMode = true
                let context = NSManagedObjectContext.weightsTestContext()
                sut = PlanRepository(context: context)
            }
            afterEach {
                sut = nil
                NSManagedObjectContext.synchronousMode = false
            }
            context("when empty plan inserted") {
                var plansAccumulator: PublisherAccumulator<[Core.Plan], Never>!
                let planToInsert = Core.Plan.make()
                beforeEach {
                    plansAccumulator = PublisherAccumulator(publisher: sut.autoupdatingPlans)
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
                
            }
        }
    }
}
