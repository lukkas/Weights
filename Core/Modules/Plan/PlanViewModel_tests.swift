//
//  PlanViewModel_tests.swift
//  Core
//
//  Created by Łukasz Kasperek on 03/09/2022.
//

@testable import Core
import Foundation
import Nimble
import TestUtilities
import XCTest
import Quick

class PlanViewModelSpec: QuickSpec {
    override func spec() {
        describe("plan view model") {
            var sut: PlanViewModel!
            var planStorage: PlanStoringStub!
            beforeEach {
                planStorage = PlanStoringStub()
                sut = PlanViewModel(planStorage: planStorage)
            }
            context("when initialized") {
                context("when no plans in storage") {
                    beforeEach {
                        planStorage.setPlans([])
                    }
                    it("will set empty active plan") {
                        expect(sut.currentPlan).to(beNil())
                    }
                    it("will set other plan to empty") {
                        expect(sut.otherPlans).to(beEmpty())
                    }
                }
                context("when one active plan in storage") {
                    beforeEach {
                        planStorage.setPlans([.make(isCurrent: true, .anyDay)])
                    }
                    it("will set active plan") {
                        expect(sut.currentPlan).toNot(beNil())
                    }
                }
                context("when one inactive plan in storage") {
                    beforeEach {
                        planStorage.setPlans([.make(isCurrent: false, .anyDay)])
                    }
                    it("will not set active plan") {
                        expect(sut.currentPlan).to(beNil())
                    }
                    it("will set one other plan") {
                        expect(sut.otherPlans).to(haveCount(1))
                    }
                    context("when another plan is added to plans") {
                        var firstPlanId: UUID!
                        beforeEach {
                            firstPlanId = sut.otherPlans.first!.id
                            planStorage.append(.make(isCurrent: false, .anyDay))
                        }
                        it("first plan will keep its id") {
                            expect(sut.otherPlans).to(containElementSatisfying({ element in
                                element.id == firstPlanId
                            }))
                        }
                    }
                }
            }
        }
    }
}
