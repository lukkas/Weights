//
//  ExerciseBatchEditor_tests.swift
//  CoreTests
//
//  Created by Łukasz Kasperek on 07/01/2023.
//

@testable import Core
import Foundation
import Nimble
import Quick

class ExerciseBatchEditorSpec: QuickSpec {
    override func spec() {
        describe("exercise batch editor") {
            var batchEditor: ExerciseBatchEditor!
            var updatesListener: PublisherListener<ExerciseBatchEditor.Update, Never>!
            
            beforeEach {
                batchEditor = ExerciseBatchEditor()
                updatesListener = PublisherListener(publisher: batchEditor.updates)
            }
            context("when no field is focused") {
                context("when value is entered") {
                    beforeEach {
                        batchEditor.valueDidChange(at: 0, value: 5)
                    }
                    it("will publish no updates") {
                        expect(updatesListener.receivedValues).to(beEmpty())
                    }
                }
            }
            context("when field is focused") {
                beforeEach {
                    batchEditor.focusDidChange(true, onIndex: 0)
                }
                context("when value is updated at index 0") {
                    beforeEach {
                        batchEditor.valueDidChange(at: 0, value: 5)
                    }
                    it("will publish updates for field 1 and above") {
                        expect(updatesListener.receivedValues).to(haveCount(1))
                        expect(updatesListener.receivedValues[0]).to(equal(
                            ExerciseBatchEditor.Update(indices: IndexSet(integersIn: 1...), value: 5)
                        ))
                    }
                }
                context("when field goes out of focus") {
                    beforeEach {
                        batchEditor.focusDidChange(false, onIndex: 0)
                    }
                    context("when value is published") {
                        beforeEach {
                            batchEditor.valueDidChange(at: 0, value: 3)
                        }
                        it("will no longer receive values") {
                            expect(updatesListener.receivedValues).to(beEmpty())
                        }
                    }
                }
                context("when focus is changed to different field") {
                    beforeEach {
                        batchEditor.focusDidChange(true, onIndex: 2)
                    }
                    context("and value is published") {
                        beforeEach {
                            batchEditor.valueDidChange(at: 2, value: 7)
                        }
                        it("will update different fields") {
                            expect(updatesListener.receivedValues).to(haveCount(1))
                            expect(updatesListener.receivedValues[0]).to(equal(
                                ExerciseBatchEditor.Update(indices: IndexSet(integersIn: 3...), value: 7)
                            ))
                        }
                    }
                }
            }
        }
    }
}
