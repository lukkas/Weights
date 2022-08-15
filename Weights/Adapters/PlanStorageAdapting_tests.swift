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
                beforeEach {
                    plansAccumulator = PublisherAccumulator(publisher: sut.autoupdatingPlans)
                    sut.insert(.make())
                }
                it("will emit updated plans") {
                    expect(plansAccumulator.updates.count).to(equal(2))
                }
            }
        }
    }
}
