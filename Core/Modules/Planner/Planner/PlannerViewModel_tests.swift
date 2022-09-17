//
//  PlannerViewModel_tests.swift
//  CoreTests
//
//  Created by Łukasz Kasperek on 03/02/2022.
//

@testable import Core
import Nimble
import Quick

@MainActor
class PlannerViewModelSpec: QuickSpec {
    override func spec() {
        describe("planner view model") {
            var sut: PlannerViewModel!
            var planStorage: PlanStoringStub!
            beforeEach {
                planStorage = PlanStoringStub()
                sut = PlannerViewModel(
                    isPresented: .constant(true),
                    planStorage: planStorage
                )
            }
            afterEach {
                sut = nil
            }
            it("will start with empty single unit template") {
                expect(sut.pages).to(haveCount(1))
                expect(sut.pages.first?.exercises).to(haveCount(0))
            }
            it("will start with disabled arrows") {
                expect(sut.leftArrowDisabled).to(beTrue())
                expect(sut.rightArrowDisabled).to(beTrue())
            }
            context("when add exercises is tapped") {
                let exercises = Exercise.make(count: 3)
                beforeEach {
                    sut.addExerciseTapped()
                    sut.exercisePickerRelay?.pick(exercises)
                }
                it("will add them to plan") {
                    expect(sut.pages.first?.exercises).to(elementsEqual(exercises, by: { exerciseUnit, exercise in
                        exerciseUnit.name == exercise.name
                    }))
                }
            }
            context("when plus is tapped") {
                beforeEach {
                    sut.plusTapped()
                }
                it("will add empty training unit") {
                    expect(sut.pages).to(haveCount(2))
                    expect(sut.pages[1].exercises).to(haveCount(0))
                }
                it("will move to newly added unit") {
                    expect(sut.visiblePage).to(equal(1))
                }
                it("will enable left arrow") {
                    expect(sut.leftArrowDisabled).to(beFalse())
                }
                it("will keep right arrow disabled") {
                    expect(sut.rightArrowDisabled).to(beTrue())
                }
                context("when left arrow is tapped") {
                    beforeEach {
                        sut.leftArrowTapped()
                    }
                    it("will go back to first page") {
                        expect(sut.visiblePage).to(equal(0))
                    }
                    it("will disable left arrow") {
                        expect(sut.leftArrowDisabled).to(beTrue())
                    }
                    it("will enable right arrow") {
                        expect(sut.rightArrowDisabled).to(beFalse())
                    }
                    context("when tapped again") {
                        beforeEach {
                            sut.leftArrowTapped()
                        }
                        it("will stay at leftmost page") {
                            expect(sut.visiblePage).to(equal(0))
                        }
                    }
                    context("when right arrow tapped") {
                        beforeEach {
                            sut.rightArrowTapped()
                        }
                        it("will move to second page again") {
                            expect(sut.visiblePage).to(equal(1))
                        }
                    }
                }
                
                context("when right arrow is tapped") {
                    beforeEach {
                        sut.rightArrowTapped()
                    }
                    it("will stay on rightmost page") {
                        expect(sut.visiblePage).to(equal(1))
                    }
                }
            }
            func prepareTwoDayPlan() {
                sut.addExerciseTapped()
                sut.exercisePickerRelay?.pick(Exercise.make(count: 3))
                sut.plusTapped()
                sut.addExerciseTapped()
                sut.exercisePickerRelay?.pick(Exercise.make(count: 5))
            }
            context("when save is tapped") {
                context("when two pages are created") {
                    beforeEach {
                        prepareTwoDayPlan()
                        sut.saveNavigationButtonTapped()
                    }
                    it("plan storage will receive plan") {
                        expect(planStorage.insertedPlans).to(haveCount(1))
                    }
                    it("plan received by plan storage will have two days") {
                        expect(planStorage.insertedPlans.last?.days).to(haveCount(2))
                    }
                    it("numer of exercises added by user will match added plan") {
                        expect(planStorage.insertedPlans.last?.days.first?.exercises).to(haveCount(3))
                    }
                }
            }
        }
    }
}