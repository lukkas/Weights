//
//  PlanRepository_tests.swift
//  Services
//
//  Created by Łukasz Kasperek on 07/08/2022.
//

import Foundation
import CoreData
import Nimble
@testable import Services
import TestUtilities
import Quick

class PlanRepositorySpec: QuickSpec {
    override func spec() {
        describe("plan repository") {
            var sut: PlanRepository!
            var moContext: NSManagedObjectContext!
            beforeEach {
                NSManagedObjectContext.synchronousMode = true
                moContext = NSManagedObjectContext.weightsTestContext()
                sut = PlanRepository(context: moContext)
            }
            afterEach {
                sut = nil
                moContext = nil
                NSManagedObjectContext.synchronousMode = false
            }
            context("when plan is added") {
                beforeEach {
                    sut.insertPlan { context in
                        let plan = context.insertObject() as Plan
                    }
//                    sut.insertPlan { plan in
//                        plan.name = "Upper-Lower"
//                        plan.days = []
//                    }
                }
                context("when plans are fetched") {
                    var accumulator: PublisherAccumulator<[Plan], Never>!
                    beforeEach {
                        accumulator = PublisherAccumulator(publisher: sut.autoupdatingPlans())
                    }
                    it("will contain added plan") {
                        expect(accumulator.update(at: 0)).to(haveCount(1))
                    }
                }
            }
        }
    }
}


