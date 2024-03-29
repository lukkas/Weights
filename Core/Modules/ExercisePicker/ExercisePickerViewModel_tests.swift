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
                let exercises = [Exercise]
                    .stubber()
                    .setting(\.name, to: "Squat", atIndices: 0)
                    .setting(\.name, to: "Deadlift", atIndices: .otherThan(0))
                    .stub(count: 3)
                
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
                
                context("when search text is entered") {
                    beforeEach {
                        sut.searchText = "Squ"
                    }
                    it("will display filtered items") {
                        expect(sut.exercises).to(equal([self.cellModel(reflecting: exercises.first!)]))
                    }
                }
                
                context("when exercise picked") {
                    let pickedIndex = 1
                    let pickedExercise = exercises[pickedIndex]
                    let pickedCellModel = cellModel(reflecting: pickedExercise)
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
    
    private func cellModel(reflecting exercise: Exercise) -> ExerciseCellViewModel {
        ExerciseCellViewModel(
            id: exercise.id,
            exerciseName: exercise.name
        )
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
