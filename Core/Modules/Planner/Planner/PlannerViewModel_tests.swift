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
            var planStorage: PlanStoringStub!
            func page(_ index: Int) -> PlannerPage {
                viewModel.pages[index]
            }
            func exercise(_ exerciseIndex: Int, fromPage page: Int = 0) -> PlannerExercise {
                viewModel.pages[page].exercises[exerciseIndex]
            }
            func set(_ setIndex: Int, fromExercise exerciseIndex: Int, page: Int = 0) -> PlannerExercise.Set {
                viewModel.pages[page].exercises[exerciseIndex].sets[setIndex]
            }
            func superset(_ supersetIndex: Int, onPage page: Int = 0) -> [Int] {
                let page = viewModel.pages[page]
                return page.exercises
                    .enumerated()
                    .compactMap { index, exercise -> Int? in
                        return exercise.supersetIndex == supersetIndex ? index : nil
                    }
            }
            beforeEach {
                planStorage = PlanStoringStub()
                viewModel = PlannerViewModel(planStorage: planStorage)
            }
            afterEach {
                viewModel = nil
            }
            it("will start with empty single unit template") {
                expect(viewModel.pages).to(haveCount(1))
                expect(viewModel.pages.first?.exercises).to(haveCount(0))
            }
            context("when add exercises is tapped") {
                let exercises = Exercise.arrayBuilder().build(count: 3)
                beforeEach {
                    viewModel.consume(.addExercise)
                    viewModel.exercisePickerRelay?.pick(exercises)
                }
                it("will add them to plan") {
                    expect(viewModel.pages.first?.exercises).to(elementsEqual(exercises, by: { exerciseUnit, exercise in
                        exerciseUnit.name == exercise.name
                    }))
                }
            }
            context("when exercise is added") {
                beforeEach {
                    let exercise = Exercise.builder().build()
                    viewModel.consume(.addExercise)
                    viewModel.exercisePickerRelay?.pick([exercise])
                }
                it("will have single set") {
                    expect(exercise(0, fromPage: 0).sets).to(haveCount(1))
                }
                context("when add set is tapped") {
                    beforeEach {
                        let exercise = exercise(0, fromPage: 0)
                        viewModel.consume(.addSet(exercise, page(0)))
                    }
                    it("will have two sets") {
                        let exercise = exercise(0, fromPage: 0)
                        expect(exercise.sets).to(haveCount(2))
                    }
                    context("when remove set action is made") {
                        beforeEach {
                            viewModel.consume(.removeSet(
                                set(1, fromExercise: 0, page: 0),
                                exercise(0, fromPage: 0),
                                page(0)
                            ))
                        }
                        it("will remove set") {
                            let exercise = exercise(0, fromPage: 0)
                            expect(exercise.sets).to(haveCount(1))
                        }
                    }
                }
            }
            context("when there are 5 exercises in a day") {
                beforeEach {
                    let exercises = Exercise.arrayBuilder().build(count: 5)
                    viewModel.consume(.addExercise)
                    viewModel.exercisePickerRelay?.pick(exercises)
                }
                context("when toggle superset is tapped on first") {
                    beforeEach {
                        viewModel.consume(.toggleSuperset(exercise(0, fromPage: 0), page(0)))
                    }
                    it("will have two exercises in first superset") {
                        expect(superset(0)).to(equal([0, 1]))
                    }
                    context("when toggle superset is tapped on second") {
                        beforeEach {
                            viewModel.consume(.toggleSuperset(exercise(1, fromPage: 0), page(0)))
                        }
                        it("will add third exercise to first superset") {
                            expect(superset(0)).to(equal([0, 1, 2]))
                        }
                    }
                    context("when toggle superset is tapped on third") {
                        beforeEach {
                            viewModel.consume(.toggleSuperset(exercise(2, fromPage: 0), page(0)))
                        }
                        it("will create second superset from third and fourth exercise") {
                            expect(superset(0)).to(equal([0, 1]))
                            expect(superset(1)).to(equal([2, 3]))
                        }
                    }
                }
            }
            context("when plus is tapped") {
                beforeEach {
                    viewModel.consume(.addPage)
                }
                it("will add empty training unit") {
                    expect(viewModel.pages).to(haveCount(2))
                    expect(viewModel.pages[1].exercises).to(haveCount(0))
                }
            }
            func prepareTwoDayPlan() {
                viewModel.consume(.addExercise)
                viewModel.exercisePickerRelay?.pick(Exercise.arrayBuilder().build(count: 3))
                viewModel.consume(.addPage)
                viewModel.consume(.pageChanged(1))
                viewModel.consume(.addExercise)
                viewModel.exercisePickerRelay?.pick(Exercise.arrayBuilder().build(count: 5))
            }
            context("when save is tapped") {
                context("when two pages are created") {
                    beforeEach {
                        prepareTwoDayPlan()
                        viewModel.consume(.save)
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
