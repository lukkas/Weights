//
//  ExerciseBatchEditor_tests.swift
//  CoreTests
//
//  Created by Łukasz Kasperek on 07/01/2023.
//

@testable import Core
import Foundation
import Nimble
import SwiftUI
import Quick

class ExerciseBatchEditorSpec: QuickSpec {
    override func spec() {
        describe("exercise batch editor") {
            var batchEditor: ExerciseBatchEditor!
            var sets: [Double?]!
            
            func simulateChange(at index: Int, to value: Double?) {
                sets[index] = value
                batchEditor.valueDidChange(at: index, value: value)
            }
            
            beforeEach {
                sets = Array(repeating: 0, count: 4)
                batchEditor = ExerciseBatchEditor(
                    sets: Binding(get: { sets }, set: { sets = $0 })
                )
            }
            context("when field is focused") {
                beforeEach {
                    batchEditor.focusDidChange(true, onIndex: 0)
                }
                context("when value is updated at index 0") {
                    beforeEach {
                        simulateChange(at: 0, to: 5)
                    }
                    it("will publish updates for field 1 and above") {
                        expect(sets).to(equal([5, 5, 5, 5]))
                    }
                }
                context("when focus is changed to different field") {
                    beforeEach {
                        batchEditor.focusDidChange(true, onIndex: 2)
                    }
                    context("and value is published") {
                        beforeEach {
                            simulateChange(at: 2, to: 7)
                            batchEditor.valueDidChange(at: 2, value: 7)
                        }
                        it("will update different fields") {
                            expect(sets).to(equal([0, 0, 7, 7]))
                        }
                    }
                }
            }
        }
    }
}
