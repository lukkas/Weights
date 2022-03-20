//
//  PlannerViewModel_tests.swift
//  CoreTests
//
//  Created by Łukasz Kasperek on 03/02/2022.
//

@testable import Core
import Nimble
import Quick

class PlannerViewModelSpec: QuickSpec {
    override func spec() {
        describe("planner view model") {
            var sut: PlannerViewModel!
            beforeEach {
                sut = PlannerViewModel()
            }
            afterEach {
                sut = nil
            }
            it("will start with empty single unit template") {
                expect(sut.trainingUnits).to(haveCount(1))
                expect(sut.trainingUnits.first?.exercises).to(haveCount(0))
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
                    expect(sut.trainingUnits.first?.exercises).to(elementsEqual(exercises, by: { exerciseUnit, exercise in
                        exerciseUnit.name == exercise.name
                    }))
                }
            }
            context("when plus is tapped") {
                beforeEach {
                    sut.plusTapped()
                }
                it("will add empty training unit") {
                    expect(sut.trainingUnits).to(haveCount(2))
                    expect(sut.trainingUnits[1].exercises).to(haveCount(0))
                }
                it("will move to newly added unit") {
                    expect(sut.visibleUnit).to(equal(1))
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
                        expect(sut.visibleUnit).to(equal(0))
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
                            expect(sut.visibleUnit).to(equal(0))
                        }
                    }
                    context("when right arrow tapped") {
                        beforeEach {
                            sut.rightArrowTapped()
                        }
                        it("will move to second page again") {
                            expect(sut.visibleUnit).to(equal(1))
                        }
                    }
                }
                
                context("when right arrow is tapped") {
                    beforeEach {
                        sut.rightArrowTapped()
                    }
                    it("will stay on rightmost page") {
                        expect(sut.visibleUnit).to(equal(1))
                    }
                }
            }
        }
    }
}
