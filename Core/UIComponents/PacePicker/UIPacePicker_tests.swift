//
//  UIPacePicker_tests.swift
//  CoreTests
//
//  Created by Łukasz Kasperek on 18/04/2022.
//

@testable import Core
import Nimble
import Quick
import UIKit

@MainActor
class UIPacePickerSpec: QuickSpec {
    override func spec() {
        describe("pace picker") {
            var sut: UIPacePicker!
            var window: UIWindow!
            
            beforeEach { @MainActor in
                window = UIWindow()
                sut = UIPacePicker()
                window.addSubview(sut)
            }
            
            afterEach {
                window = nil
                sut = nil
            }
            
            context("when 1st number is entered") {
                beforeEach { @MainActor in
                    sut.insertText("1")
                }
                it("will set eccentric phase") { @MainActor in
                    expect(sut.pace.eccentric).to(equal(1))
                }
                context("when 2nd digit is entered") {
                    beforeEach { @MainActor in
                        sut.insertText("2")
                    }
                    it("will set isometric phase") { @MainActor in
                        expect(sut.pace.isometric).to(equal(2))
                    }
                    context("when 3rd digit is entered") {
                        beforeEach { @MainActor in
                            sut.insertText("3")
                        }
                        it("will set concentric phase") { @MainActor in
                            expect(sut.pace.concentric).to(equal(3))
                        }
                        context("when 4th number is entered") {
                            beforeEach { @MainActor in
                                sut.insertText("4")
                            }
                            it("will set starting point") { @MainActor in
                                expect(sut.pace.startingPoint).to(equal(4))
                            }
                            context("when more text is inserted and then char is deleted") {
                                beforeEach { @MainActor in
                                    for _ in 0 ..< 10 {
                                        sut.insertText("4")
                                    }
                                    sut.deleteBackward()
                                }
                                it("will remove starting point") { @MainActor in
                                    expect(sut.pace.startingPoint).to(beNil())
                                }
                            }
                        }
                    }
                    context("when X is insert as 3rd char") {
                        beforeEach { @MainActor in
                            sut.insertText("X")
                        }
                        it("will set explosive concentric phase") { @MainActor in
                            expect(sut.pace.concentric).to(equal(.explosive))
                        }
                        context("when 4th number is entered") {
                            beforeEach { @MainActor in
                                sut.insertText("1")
                            }
                            it("will keep concentric phase as explosive") { @MainActor in
                                expect(sut.pace.concentric).to(equal(.explosive))
                            }
                            it("will set 4th number") { @MainActor in
                                expect(sut.pace.startingPoint).to(equal(1))
                            }
                        }
                    }
                }
                context("when backspace entered") {
                    beforeEach { @MainActor in
                        sut.deleteBackward()
                    }
                    it("will set eccentric phase back to nil") { @MainActor in
                        expect(sut.pace.eccentric).to(beNil())
                    }
                    context("when another backspace and then number is entered") {
                        beforeEach { @MainActor in
                            sut.deleteBackward()
                            sut.insertText("5")
                        }
                        it("will set eccentric phase") { @MainActor in
                            expect(sut.pace.eccentric).to(equal(5))
                        }
                    }
                }
            }
        }
    }
}
