//
//  UIPickerTextFieldTests.swift
//  CoreTests
//
//  Created by Łukasz Kasperek on 29/12/2020.
//  Copyright © 2020 Łukasz Kasperek. All rights reserved.
//

@testable import Core
import XCTest

class UIPickerTextFieldTests: XCTestCase {
    var sut: UIPickerTextField!
    
    override func setUpWithError() throws {
        sut = UIPickerTextField()
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    func test_insertText_whenFirstNumberIsEntered() {
        // when
        sut.insertText("2")
        
        // then
        XCTAssertEqual(sut.value, 2)
    }
    
    func test_insertingMultipleNumbers() {
        // when
        sut.insertText("2")
        sut.insertText("3")
        sut.insertText("4")
        
        // then
        XCTAssertEqual(sut.value, 234)
    }
    
    func test_backspace_whenNoNumnbersWhenEntered_shouldDoNothing() {
        // when
        sut.deleteBackward()
        
        // then
        XCTAssertEqual(sut.value, nil)
    }
    
    func test_backspace_whenOneNumberWasEntered() {
        // given
        sut.insertText("2")
        
        // when
        sut.deleteBackward()
        
        // then
        XCTAssertEqual(sut.value, nil)
    }
    
    func test_backspace_whenMultipleNumbersWereEntered() {
        // given
        sut.insertText("2")
        sut.insertText("2")
        sut.insertText("1")
        
        // when
        sut.deleteBackward()
        
        // then
        XCTAssertEqual(sut.value, 22)
    }
    
    func test_enteringFloatingPointNumber() {
        // given
        sut.mode = .floatingPoint
        
        // when
        sut.insertText("9")
        sut.insertText(".")
        sut.insertText("8")
        
        // then
        XCTAssertEqual(sut.value, 9.8)
    }
    
    func test_initialKeyboardSettingAndMode() {
        XCTAssertEqual(sut.mode, .wholes)
        XCTAssertEqual(sut.keyboardType, .numberPad)
    }
    
    func test_keyboardType_whenModeIsChangedToFloatingPoint_shouldChangeKeyboardType() {
        // when
        sut.mode = .floatingPoint
        
        // then
        XCTAssertEqual(sut.keyboardType, .decimalPad)
    }
    
    func test_keybordType_whenModeIsChangedToFloatingAndBack_shouldChangeKeyboardType() {
        // given
        sut.mode = .floatingPoint
        
        // when
        sut.mode = .wholes
        
        // then
        XCTAssertEqual(sut.keyboardType, .numberPad)
    }
    
    func test_enteringDotInWholesMode_shouldBeIgnored() {
        // given
        sut.mode = .wholes
        
        // when
        sut.insertText("5")
        sut.insertText(".")
        sut.insertText("4")
        
        // then
        XCTAssertEqual(sut.value, 54)
    }
    
    func test_backspaceInFloatingPointMode_whenDotIsRemoved() {
        // given
        sut.mode = .floatingPoint
        
        // when
        sut.insertText("7")
        sut.insertText(".")
        sut.deleteBackward()
        sut.insertText("7")
        
        // then
        XCTAssertEqual(sut.value, 77)
    }
    
    func test_backspaceInFloatingPointMode_whenNumberAfterDotIsRemoved() {
        // given
        sut.mode = .floatingPoint
        
        // when
        sut.insertText("7")
        sut.insertText(".")
        sut.insertText("7")
        sut.deleteBackward()
        sut.insertText("1")
        
        // then
        XCTAssertEqual(sut.value, 7.1)
    }
    
    func test_floatingPointNumberWithThreeDigitsAfterDecimalSeparator() {
        // given
        sut.mode = .floatingPoint
        
        // when
        sut.insertText("0")
        sut.insertText(".")
        sut.insertText("1")
        sut.insertText("2")
        sut.insertText("3")
        
        // then
        XCTAssertEqual(sut.value, 0.123)
    }
    
    func test_floatingPointWithManyDigitsAndBackspacesUsed() {
        // given
        sut.mode = .floatingPoint
        
        // when
        sut.insertText("1")
        sut.insertText(".")
        sut.insertText("1")
        sut.insertText("2")
        sut.insertText("8")
        sut.deleteBackward()
        sut.deleteBackward()
        sut.insertText("6")
        sut.insertText("8")
        sut.insertText("3")
        sut.insertText("1")
        
        // then
        XCTAssertEqual(sut.value, 1.16831)
    }
    
    func test_displayingLongFloatingPointNumbers() {
        // given
        sut.mode = .floatingPoint
        
        // when
        sut.insertText("1")
        sut.insertText(".")
        sut.insertText("1")
        sut.insertText("6")
        sut.insertText("8")
        sut.insertText("9")
        sut.insertText("9")
        
        // then
        XCTAssertEqual(sut.textValue, "1.16899")
    }
    
    func test_displayingShortFloatingPointNumbers() {
        // given
        sut.mode = .floatingPoint
        
        // when
        sut.insertText("5")
        sut.insertText(".")
        sut.insertText("2")
        
        // then
        XCTAssertEqual(sut.textValue, "5.2")
    }
    
    func test_displayingWholeNumbers() {
        // given
        sut.mode = .wholes
        
        // when
        sut.insertText("1")
        sut.insertText("2")
        
        // then
        XCTAssertEqual(sut.textValue, "12")
    }
}
