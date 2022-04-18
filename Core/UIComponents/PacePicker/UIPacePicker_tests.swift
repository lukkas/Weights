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

class UIPacePickerSpec: QuickSpec {
    override func spec() {
        describe("pace picker") {
            var sut: UIPacePicker!
            var window: UIWindow!
            
            beforeEach {
                window = UIWindow()
                sut = UIPacePicker()
                window.addSubview(sut)
            }
            
            afterEach {
                window = nil
                sut = nil
            }
            
            context("when 1st number is entered") {
                beforeEach {
                    sut.insertText("1")
                }
                it("will set eccentric phase") {
                    expect(sut.pace.eccentric).to(equal(1))
                }
                context("when 2nd digit is entered") {
                    beforeEach {
                        sut.insertText("2")
                    }
                    it("will set isometric phase") {
                        expect(sut.pace.isometric).to(equal(2))
                    }
                    context("when 3rd digit is entered") {
                        beforeEach {
                            sut.insertText("3")
                        }
                        it("will set concentric phase") {
                            expect(sut.pace.concentric).to(equal(3))
                        }
                        context("when 4th number is entered") {
                            beforeEach {
                                sut.insertText("4")
                            }
                            it("will set starting point") {
                                expect(sut.pace.startingPoint).to(equal(4))
                            }
                        }
                    }
                }
                context("when backspace entered") {
                    beforeEach {
                        sut.deleteBackward()
                    }
                    it("will set eccentric phase back to nil") {
                        expect(sut.pace.eccentric).to(beNil())
                    }
                    context("when another backspace and then number is entered") {
                        beforeEach {
                            sut.deleteBackward()
                            sut.insertText("5")
                        }
                        it("will set eccentric phase") {
                            expect(sut.pace.eccentric).to(equal(5))
                        }
                    }
                }
            }
        }
    }
}
