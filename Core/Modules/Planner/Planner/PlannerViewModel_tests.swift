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
            func savedPlan() -> Plan? {
                planStorage.insertedPlans.last
            }
            func savedExercise(at exerciseIndex: Int, day: Int) -> PlannedExercise? {
                savedPlan()?.days[day].exercises[exerciseIndex]
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
                let exercises = [Exercise].dummies(count: 3)
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
                    let exercise = Exercise.stubber().stub()
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
                    let exercises = [Exercise].stubber().stub(count: 5)
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
                        context("when toggle superset is tapped on second") {
                            beforeEach {
                                viewModel.consume(.toggleSuperset(exercise(1, fromPage: 0), page(0)))
                            }
                            it("will join both supersets") {
                                expect(superset(0)).to(equal([0, 1, 2, 3]))
                            }
                            context("when toggled on third") {
                                beforeEach {
                                    viewModel.consume(.toggleSuperset(exercise(2, fromPage: 0), page(0)))
                                }
                                it("will only remove last exercise from superset") {
                                    expect(superset(0)).to(equal([0, 1, 2]))
                                }
                            }
                            context("when toggled on first") {
                                beforeEach {
                                    viewModel.consume(.toggleSuperset(exercise(0, fromPage: 0), page(0)))
                                }
                                it("will only remove first exercise from superset") {
                                    expect(superset(0)).to(equal([1, 2, 3]))
                                }
                            }
                            context("when toggled on second") {
                                beforeEach {
                                    viewModel.consume(.toggleSuperset(exercise(1, fromPage: 0), page(0)))
                                }
                                it("will split into two supersets") {
                                    expect(superset(0)).to(equal([0, 1]))
                                    expect(superset(1)).to(equal([2, 3]))
                                }
                            }
                        }
                        context("when toggle superset is tapped on first") {
                            beforeEach {
                                viewModel.consume(.toggleSuperset(exercise(0, fromPage: 0), page(0)))
                            }
                            it("will leave only first superset") {
                                expect(superset(0)).to(equal([]))
                                expect(superset(1)).to(equal([2, 3]))
                            }
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
                viewModel.exercisePickerRelay?.pick([Exercise].stubber().stub(count: 3))
                viewModel.consume(.addPage)
                viewModel.consume(.pageChanged(1))
                viewModel.consume(.addExercise)
                viewModel.exercisePickerRelay?.pick([Exercise].stubber().stub(count: 5))
            }
            context("when two pages are created and save is tapped") {
                beforeEach {
                    prepareTwoDayPlan()
                    viewModel.consume(.save)
                }
                it("plan storage will receive plan") {
                    expect(planStorage.insertedPlans).to(haveCount(1))
                }
                it("plan received by plan storage will have two days") {
                    expect(savedPlan()?.days).to(haveCount(2))
                }
                it("numer of exercises added by user will match added plan") {
                    expect(savedPlan()?.days.first?.exercises).to(haveCount(3))
                }
            }
            context("when two sets are added to first exercise") {
                beforeEach {
                    viewModel.consume(.addExercise)
                    viewModel.exercisePickerRelay?.pick([Exercise].stubber().stub(count: 1))
                    viewModel.consume(.addSet(exercise(0), page(0)))
                    viewModel.consume(.addSet(exercise(0), page(0)))
                }
                context("when save is tapped") {
                    beforeEach {
                        viewModel.consume(.save)
                    }
                    it("will save exercise with 3 sets") {
                        expect(savedPlan()?.days.first?.exercises.first?.sets).to(haveCount(3))
                    }
                }
                context("when sets have reps and weight set and set is saved") {
                    beforeEach {
                        viewModel.pages[0].exercises[0].sets[0].weight = 100
                        viewModel.pages[0].exercises[0].sets[0].repCount = 8
                        viewModel.consume(.save)
                    }
                    it("will be passed to saved plan") {
                        expect(savedExercise(at: 0, day: 0)?.sets[0].weight.value).to(equal(100))
                        expect(savedExercise(at: 0, day: 0)?.sets[0].volume).to(equal(8))
                    }
                }
                context("when pace is set") {
                    beforeEach { exampleMetadata in
                        viewModel.pages[0].exercises[0].pace = UIPacePicker.InputState(
                            eccentric: 3, isometric: 1, concentric: .explosive, startingPoint: 0
                        )
                        viewModel.consume(.save)
                    }
                    it("will pass it") {
                        let expectedPace = Pace(eccentric: 3, isometric: 1, concentric: .explosive, startingPoint: 0)
                        expect(savedExercise(at: 0, day: 0)?.pace).to(equal(expectedPace))
                    }
                }
            }
            context("when there are supersets in plan") {
                beforeEach {
                    viewModel.consume(.addExercise)
                    viewModel.exercisePickerRelay?.pick([Exercise].stubber().stub(count: 5))
                    viewModel.consume(.toggleSuperset(exercise(0), page(0)))
                    viewModel.consume(.toggleSuperset(exercise(1), page(0)))
                    viewModel.consume(.toggleSuperset(exercise(3), page(0)))
                    viewModel.consume(.save)
                }
                it("will accordingly set creates supersets fields") {
                    expect(savedExercise(at: 0, day: 0)?.createsSupersets).to(beTrue())
                    expect(savedExercise(at: 1, day: 0)?.createsSupersets).to(beTrue())
                    expect(savedExercise(at: 2, day: 0)?.createsSupersets).to(beFalse())
                    expect(savedExercise(at: 3, day: 0)?.createsSupersets).to(beTrue())
                    expect(savedExercise(at: 4, day: 0)?.createsSupersets).to(beFalse())
                }
            }
        }
    }
}
