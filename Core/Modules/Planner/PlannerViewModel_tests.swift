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
            }
        }
    }
}
