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
            var viewModel: PlannerViewModel!
            var presenter: PlannerPresenter!
            var planStorage: PlanStoringStub!
            var firstDay: PlannerPageViewModel {
                viewModel.pages[0]
            }
            beforeEach {
                planStorage = PlanStoringStub()
                viewModel = PlannerViewModel(isPresented: .constant(true))
                presenter = PlannerPresenter(
                    viewModel: viewModel,
                    planStorage: planStorage
                )
            }
            afterEach {
                viewModel = nil
            }
            it("will start with empty single unit template") {
                expect(viewModel.pages).to(haveCount(1))
                expect(viewModel.pages.first?.exercises).to(haveCount(0))
            }
            it("will start with disabled arrows") {
                expect(viewModel.leftArrowDisabled).to(beTrue())
                expect(viewModel.rightArrowDisabled).to(beTrue())
            }
            context("when add exercises is tapped") {
                let exercises = Exercise.arrayBuilder().build(count: 3)
                beforeEach {
                    presenter.addExerciseTapped()
                    viewModel.exercisePickerRelay?.pick(exercises)
                }
                it("will add them to plan") {
                    expect(viewModel.pages.first?.exercises).to(elementsEqual(exercises, by: { exerciseUnit, exercise in
                        exerciseUnit.headerRows[0].name == exercise.name
                    }))
                }
            }
            context("when exercise is added") {
                var addedExercise: PlannerExerciseViewModel!
                beforeEach {
                    let exercise = Exercise.builder().build()
                    presenter.addExerciseTapped()
                    viewModel.exercisePickerRelay?.pick([exercise])
                    addedExercise = firstDay.exercises[0]
                }
                it("will have single variation with single set") {
                    expect(addedExercise.variations).to(haveCount(1))
                    expect(addedExercise.variations[0].numberOfSets).to(equal(1))
                }
                context("when add variation is tapped") {
                    beforeEach {
                        addedExercise.addVariationTapped()
                    }
                    it("will add another variation with single set") {
                        expect(addedExercise.variations).to(haveCount(2))
                        expect(addedExercise.variations[1].numberOfSets).to(equal(1))
                    }
                    context("when number of sets is set to zero") {
                        beforeEach {
                            addedExercise.variations[1].numberOfSets = 0
                        }
                        it("will remove variation") {
                            expect(addedExercise.variations).to(haveCount(1))
                        }
                    }
                }
            }
            context("when there are 3 exercises in a day") {
                beforeEach {
                    let exercises = Exercise.arrayBuilder().build(count: 3)
                    presenter.addExerciseTapped()
                    viewModel.exercisePickerRelay?.pick(exercises)
                }
                context("when add superset is tapped on first") {
                    beforeEach {
                        firstDay.exercises[0].addToSuperset()
                    }
                    it("will have to exercises in first superset") {
                        expect(firstDay.exercises[0].headerRows).to(haveCount(2))
                    }
                    it("will have two exercises on page") {
                        expect(firstDay.exercises).to(haveCount(2))
                    }
                }
            }
            context("when plus is tapped") {
                beforeEach {
                    presenter.plusTapped()
                }
                it("will add empty training unit") {
                    expect(viewModel.pages).to(haveCount(2))
                    expect(viewModel.pages[1].exercises).to(haveCount(0))
                }
                it("will move to newly added unit") {
                    expect(viewModel.visiblePage).to(equal(1))
                }
                it("will enable left arrow") {
                    expect(viewModel.leftArrowDisabled).to(beFalse())
                }
                it("will keep right arrow disabled") {
                    expect(viewModel.rightArrowDisabled).to(beTrue())
                }
                context("when left arrow is tapped") {
                    beforeEach {
                        presenter.leftArrowTapped()
                    }
                    it("will go back to first page") {
                        expect(viewModel.visiblePage).to(equal(0))
                    }
                    it("will disable left arrow") {
                        expect(viewModel.leftArrowDisabled).to(beTrue())
                    }
                    it("will enable right arrow") {
                        expect(viewModel.rightArrowDisabled).to(beFalse())
                    }
                    context("when tapped again") {
                        beforeEach {
                            presenter.leftArrowTapped()
                        }
                        it("will stay at leftmost page") {
                            expect(viewModel.visiblePage).to(equal(0))
                        }
                    }
                    context("when right arrow tapped") {
                        beforeEach {
                            presenter.rightArrowTapped()
                        }
                        it("will move to second page again") {
                            expect(viewModel.visiblePage).to(equal(1))
                        }
                    }
                }
                
                context("when right arrow is tapped") {
                    beforeEach {
                        presenter.rightArrowTapped()
                    }
                    it("will stay on rightmost page") {
                        expect(viewModel.visiblePage).to(equal(1))
                    }
                }
            }
            func prepareTwoDayPlan() {
                presenter.addExerciseTapped()
                viewModel.exercisePickerRelay?.pick(Exercise.arrayBuilder().build(count: 3))
                presenter.plusTapped()
                presenter.addExerciseTapped()
                viewModel.exercisePickerRelay?.pick(Exercise.arrayBuilder().build(count: 5))
            }
            context("when save is tapped") {
                context("when two pages are created") {
                    beforeEach {
                        prepareTwoDayPlan()
                        presenter.saveNavigationButtonTapped()
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
