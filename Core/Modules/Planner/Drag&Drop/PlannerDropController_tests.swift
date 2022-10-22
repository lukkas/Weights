//
//  PlannerDropController_tests.swift
//  CoreTests
//
//  Created by Łukasz Kasperek on 17/04/2022.
//

import Nimble
import Quick
@testable import Core
import SwiftUI

class PlannerDropControllerSpec: QuickSpec {
    override func spec() {
        describe("view model") {
            var viewModel: PlannerViewModel!
            var presenter: PlannerPresenter!
            var planStorage: PlanStoringStub!
            
            beforeEach {
                planStorage = PlanStoringStub()
                viewModel = PlannerViewModel(isPresented: .constant(true))
                presenter = PlannerPresenter(viewModel: viewModel, planStorage: planStorage)
            }
            
            context("when first page has two items") {
                var originalExercises: [PlannerExerciseViewModel]!
                beforeEach {
                    let exercises = Exercise.arrayBuilder().build(count: 2)
                    addExercises(exercises)
                    originalExercises = page(0).exercises
                }
                
                context("first exercise is dragged over second") {
                    beforeEach {
                        enterDrop(
                            target: .exercise(item(0, 1)),
                            dragged: item(0, 0)
                        )
                    }
                    
                    it("will swap items") {
                        expect(page(0).exercises).to(equal(originalExercises.reversed()))
                    }
                }
                
                context("when second page is added") {
                    beforeEach {
                        presenter.plusTapped()
                    }
                    
                    context("when exercise is dragged to second page") {
                        beforeEach {
                            enterDrop(target: .emptyPage(page(1)), dragged: item(0, 0))
                        }
                        
                        it("will remove it from original place") {
                            expect(page(0).exercises).to(equal([originalExercises[1]]))
                        }
                        
                        it("will add drag exercise to second page") {
                            expect(page(1).exercises).to(equal([originalExercises[0]]))
                        }
                        
                        context("when another exercise is dragged to second page") {
                            beforeEach {
                                enterDrop(target: .exercise(item(1, 0)), dragged: item(0, 0))
                            }
                            
                            it("will empty first page") {
                                expect(page(0).exercises).to(beEmpty())
                            }
                            
                            it("will insert moved exercise to second page") {
                                expect(page(1).exercises).to(equal(originalExercises.reversed()))
                            }
                        }
                    }
                }
            }
            
            func addExercises(_ exercises: [Exercise]) {
                presenter.addExerciseTapped()
                viewModel.exercisePickerRelay?.pick(exercises)
            }
            
            func item(_ page: Int, _ item: Int) -> PlannerExerciseViewModel {
                return viewModel.pages[page].exercises[item]
            }
            
            func page(_ page: Int) -> PlannerPageViewModel {
                return viewModel.pages[page]
            }
            
            func enterDrop(
                target: PlannerDraggingTarget,
                dragged: PlannerExerciseViewModel
            ) {
                let drop = PlannerDropController(
                    target: target,
                    currentlyDragged: .constant(dragged),
                    pages: Binding(get: { viewModel.pages }, set: { viewModel.pages = $0 })
                )
                drop.dropEntered()
            }
        }
    }
}
