//
//  ExercisePickerViewModel_tests.swift
//  CoreTests
//
//  Created by Łukasz Kasperek on 21/11/2021.
//  Copyright © 2021 Łukasz Kasperek. All rights reserved.
//

import XCTest
@testable import Core
import Nimble
import Quick

class ExercisePickerViewModelSpec: QuickSpec {
    override func spec() {
        describe("exercise picker view model") {
            var sut: ExercisePickerViewModel!
            var exerciseStorage: ExerciseStoringStub!
            var pickerRelayReader: ExercisePickerRelayReader!
            
            beforeEach {
                exerciseStorage = ExerciseStoringStub()
                pickerRelayReader = ExercisePickerRelayReader()
                sut = ExercisePickerViewModel(
                    exerciseStorage: exerciseStorage,
                    pickedRelay: pickerRelayReader.relay
                )
            }
            
            afterEach {
                exerciseStorage = nil
                sut = nil
            }
            
            context("given populated storage") {
                let exercises = Exercise.make(count: 3)
                
                beforeEach {
                    exerciseStorage.preconfigure_populate(with: exercises)
                    sut.handleViewAppeared()
                }
                
                it("has cell view models matching exercises") {
                    expect(sut.exercises).to(elementsEqual(exercises, by: { cellViewModel, exercise in
                        cellViewModel.exerciseName == exercise.name
                    }))
                }
                
                it("has add button disabled") {
                    expect(sut.addButtonDisabled).to(beTrue())
                }
                
                context("when exercise picked") {
                    let pickedIndex = 1
                    let pickedExercise = exercises[pickedIndex]
                    let pickedCellModel = ExerciseCellViewModel(
                        id: pickedExercise.id,
                        exerciseName: pickedExercise.name
                    )
                    beforeEach {
                        sut.pick(pickedCellModel)
                    }
                    
                    it("will remove exercise from exercises") {
                        expect(sut.exercises).toNot(contain(pickedCellModel))
                    }
                    
                    it("will populate picked exercises array") {
                        expect(sut.pickedExercises).to(contain(pickedCellModel))
                    }
                    
                    it("will enable add button") {
                        expect(sut.addButtonDisabled).to(beFalse())
                    }
                    
                    context("when removed back") {
                        beforeEach {
                            sut.remove(pickedCellModel)
                        }
                        
                        it("will remove from picked exercises") {
                            expect(sut.pickedExercises).toNot(contain(pickedCellModel))
                        }
                        
                        it("will add back to exercises") {
                            expect(sut.exercises).to(contain(pickedCellModel))
                        }
                        
                        it("will keep original exercise order") {
                            expect(sut.exercises[pickedIndex]).to(equal(pickedCellModel))
                        }
                        
                        it("will disable add button") {
                            expect(sut.addButtonDisabled).to(beTrue())
                        }
                    }
                    
                    context("when add tapped") {
                        beforeEach {
                            sut.handleAddTapped()
                        }
                        
                        it("will call relay with picked exercise") {
                            expect(pickerRelayReader.pickedExercises).to(equal([pickedExercise]))
                        }
                    }
                }
            }
        }
    }
}

private class ExercisePickerRelayReader {
    private(set) var relay: ExercisePickerRelay!
    private(set) var pickedExercises: [Exercise]?
    
    init() {
        relay = ExercisePickerRelay(onPicked: { [weak self] pickedExercises in
            self?.pickedExercises = pickedExercises
        })
    }
}
