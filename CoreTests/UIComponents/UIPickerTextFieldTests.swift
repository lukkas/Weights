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
    var window: UIWindow!
    var sut: UIPickerTextField!
    var panInjector: UIPanGestureRecognizerMockInjector!
    var tapInjector: UITapGestureRecognizerMockInjector!
    var selectionHapticsInjector: UISelectionFeedbackGeneratorInjector!
    var notificationHapticsInjector: UINotificationFeedbackGeneratorInjector!
    
    override func setUpWithError() throws {
        window = UIWindow()
        panInjector = UIPanGestureRecognizerMockInjector()
        tapInjector = UITapGestureRecognizerMockInjector()
        selectionHapticsInjector = UISelectionFeedbackGeneratorInjector()
        notificationHapticsInjector = UINotificationFeedbackGeneratorInjector()
        sut = UIPickerTextField()
        window.addSubview(sut)
    }

    override func tearDownWithError() throws {
        window = nil
        sut = nil
        tapInjector = nil
        panInjector = nil
        selectionHapticsInjector = nil
        notificationHapticsInjector = nil
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
    
    func test_floatingPointFormatting_whenDecimalSeparatorWasLastEntered_shouldBeDisplayed() throws {
        // given
        try preconfigure_enteringFloatingPoints()
        
        // when
        sut.insertText("3")
        sut.insertText(".")
        
        // then
        XCTAssertEqual(sut.textValue, "3.")
    }
    
    func test_floatingPointFormatting_whenDecimalSeparatorWasLastEnteredAndSutStopsBeingFirstResponder_shouldRemoveSeparator() throws {
        // given
        try preconfigure_enteringFloatingPoints()
        sut.insertText("3")
        sut.insertText(".")
        
        // when
        try toggleFirstResponderState()
        
        // then
        XCTAssertEqual(sut.textValue, "3")
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
    
    func test_gesturesAreAdded() throws {
        _ = try getPan()
        _ = try getTap()
    }
    
    func test_tap_whenTapped_shouldHighlightWithBorder() throws {
        // when
        try getTap().tap()
        
        // then
        XCTAssertEqual(sut.layer.borderWidth, 2)
    }
    
    func test_tap_whenTappedSecondTime_shouldRemoveBorderHighlight() throws {
        // given
        try getTap().tap()
        
        // when
        try getTap().tap()
        
        // then
        verify_isFieldHighlighted(false)
    }
    
    private func verify_isFieldHighlighted(_ highlighted: Bool = true) {
        let expectedWidth: CGFloat = highlighted ? 2 : 0
        XCTAssertEqual(sut.layer.borderWidth, expectedWidth)
    }
    
    func test_panning_whenPanningStarts_shouldHighlightWithBorder() throws {
        // when
        try getPan().beginPanning()
        
        // then
        verify_isFieldHighlighted()
    }
    
    func test_panning_whenPansByJumpThreshold_shouldIncrementValue() throws {
        // given
        let pan = try preconfigure_beganPanning(initialValue: 1, jump: 1)
        
        // when
        pan.continuePanning(by: panTranslation(toIncreaseValueBy: 1))
        
        // then
        XCTAssertEqual(sut.value, 2)
    }
    
    func test_panning_whenPansSlowlyByFractionsOfJump_shouldWork() throws {
        // given
        let pan = try preconfigure_beganPanning(initialValue: 1, jump: 1)
        
        // when
        pan.continuePanning(by: panTranslation(toIncreaseValueBy: 0.5))
        XCTAssertEqual(sut.value, 1)
        pan.continuePanning(by: panTranslation(toIncreaseValueBy: 0.5))
        
        // then
        XCTAssertEqual(sut.value, 2)
    }
    
    func test_panning_shouldRespectJumpSetInterval() throws {
        // given
        let pan = try preconfigure_beganPanning(initialValue: 8, jump: 0.3)
        
        // when
        pan.continuePanning(by: panTranslation(toIncreaseValueBy: 1))
        
        // then
        XCTAssertEqual(sut.value, 8.3)
    }
    
    func test_panning_whenPanningEnds_shouldSetValueStay() throws {
        // given
        let pan = try preconfigure_beganPanning(initialValue: 2, jump: 0.5)
        pan.continuePanning(by: panTranslation(toIncreaseValueBy: 2))
        XCTAssertEqual(sut.value, 3)
        
        // when
        pan.endPanning()
        
        // then
        XCTAssertEqual(sut.value, 3)
    }
    
    func test_panning_whenPanningIsCancelled_shouldResetValue() throws {
        // given
        let pan = try preconfigure_beganPanning(initialValue: 2, jump: 0.5)
        pan.continuePanning(by: panTranslation(toIncreaseValueBy: 3))
        XCTAssertEqual(sut.value, 3.5)
        
        // when
        pan.cancelPanning()
        
        // then
        XCTAssertEqual(sut.value, 2)
    }
    
    func test_panning_whenPanningEnds_shouldRemoveHighlight() throws {
        // given
        let pan = try preconfigure_beganPanning(initialValue: 1, jump: 1)
        pan.continuePanning(by: panTranslation(toIncreaseValueBy: 1))
        verify_isFieldHighlighted()
        
        // when
        pan.endPanning()
        
        // then
        verify_isFieldHighlighted(false)
    }
    
    func test_panning_whenPanningIsCancelled_shouldRemoveHighlight() throws {
        // given
        let pan = try preconfigure_beganPanning(initialValue: 1, jump: 1)
        pan.continuePanning(by: panTranslation(toIncreaseValueBy: 1))
        verify_isFieldHighlighted()
        
        // when
        pan.cancelPanning()
        
        // then
        verify_isFieldHighlighted(false)
    }
    
    func test_panning_whenPanningEndsButStaysFirstResponder_shouldLeaveHighlight() throws {
        // given
        try getTap().tap()
        let pan = try preconfigure_beganPanning(initialValue: 1, jump: 1)
        
        // when
        pan.cancelPanning()
        
        // then
        verify_isFieldHighlighted()
    }
    
    func test_selectionHaptics_whenGestureCausesValueChange_shouldTap() throws {
        // given
        let pan = try preconfigure_beganPanning(initialValue: 1, jump: 1)
        let haptics = try getSelectionHaptics()
        XCTAssertEqual(haptics.selectionChangedCallsCount, 0)
        
        // when
        pan.continuePanning(by: panTranslation(toIncreaseValueBy: 1))
        
        // then
        XCTAssertEqual(haptics.selectionChangedCallsCount, 1)
    }
    
    func test_selectionHaptics_whenGestureCauseMultipleValueJumps_shouldStillTapOnce() throws {
        // given
        let pan = try preconfigure_beganPanning(initialValue: 1, jump: 1)
        let haptics = try getSelectionHaptics()
        
        // when
        pan.continuePanning(by: panTranslation(toIncreaseValueBy: 5))
        
        // then
        XCTAssertEqual(haptics.selectionChangedCallsCount, 1)
    }
    
    func test_selectionHaptics_whenMultipleGestureChangesAreRegistered() throws {
        // given
        let pan = try preconfigure_beganPanning(initialValue: 1, jump: 1)
        let haptics = try getSelectionHaptics()
        
        // when
        pan.continuePanning(by: panTranslation(toIncreaseValueBy: 1))
        pan.continuePanning(by: panTranslation(toIncreaseValueBy: 1))
        pan.continuePanning(by: panTranslation(toIncreaseValueBy: 1))
        
        // then
        XCTAssertEqual(haptics.selectionChangedCallsCount, 3)
    }
    
    func test_panning_whenNoJumpIntervalIsSet_shouldIgnorePanning() throws {
        // given
        sut.value = 5
        sut.jumpInterval = nil
        
        // when
        let pan = try getPan()
        pan.beginPanning()
        pan.continuePanning(by: CGPoint(x: 0, y: 100))
        pan.endPanning()
        
        // then
        XCTAssertEqual(sut.value, 5)
    }
    
    func test_minMaxRange_whenUserTriesToTypeInTooLargeValue_shouldIgnoreInput() throws {
        // given
        sut.minMaxRange = 0 ... 1000
        sut.insertText("100")
        XCTAssertEqual(sut.value, 100)
        
        // when
        sut.insertText("9")
        
        // then
        XCTAssertEqual(sut.value, 100)
    }
    
    func test_minMaxRange_whenUserPanOverValidRange_shouldIgnoreInput() throws {
        // given
        sut.minMaxRange = 0 ... 10
        let pan = try preconfigure_beganPanning(initialValue: 10, jump: 1)
        
        // when
        pan.continuePanning(by: panTranslation(toIncreaseValueBy: 1))
        
        // then
        XCTAssertEqual(sut.value, 10)
    }
    
    func test_outOfRangeHaptics_whenUserTriesToTypeInNumberOfOfRange_shouldGiveFeedback() throws {
        // given
        sut.minMaxRange = 0 ... 10
        sut.insertText("9")
        
        // when
        sut.insertText("9")
        
        // then
        let haptics = try getNotificationHaptics()
        XCTAssertEqual(haptics.receivedNotifications, [.warning])
    }
    
    func test_outOfRangeHaptics_whenUserPansOverAllowedRange() throws {
        // given
        sut.minMaxRange = 0 ... 100
        let pan = try preconfigure_beganPanning(initialValue: 100, jump: 1)
        
        // when
        pan.continuePanning(by: panTranslation(toIncreaseValueBy: 1))
        
        // then
        let haptics = try getNotificationHaptics()
        XCTAssertEqual(haptics.receivedNotifications, [.warning])
    }
    
    func test_outOfRangeHatpics_whenUserKeepsPanningOverRange_shouldGiveFeedbackOnlyOnce() throws {
        // given
        sut.minMaxRange = 0 ... 100
        let pan = try preconfigure_beganPanning(initialValue: 100, jump: 1)
        
        // when
        pan.continuePanning(by: panTranslation(toIncreaseValueBy: 1))
        pan.continuePanning(by: panTranslation(toIncreaseValueBy: 1))
        pan.continuePanning(by: panTranslation(toIncreaseValueBy: 1))
        
        // then
        let haptics = try getNotificationHaptics()
        XCTAssertEqual(haptics.receivedNotifications, [.warning])
    }
    
    func test_outOfRangeHaptics_whenUserPansMultipleTimeOverRangeStepsBackAndThenPansAgain_shouldGiveFeedbackTwoTimes() throws {
        // given
        sut.minMaxRange = 0 ... 100
        let pan = try preconfigure_beganPanning(initialValue: 100, jump: 1)
        
        // when
        pan.continuePanning(by: panTranslation(toIncreaseValueBy: 1))
        pan.continuePanning(by: panTranslation(toIncreaseValueBy: 1))
        pan.continuePanning(by: panTranslation(toIncreaseValueBy: -1))
        pan.continuePanning(by: panTranslation(toIncreaseValueBy: 1))
        pan.continuePanning(by: panTranslation(toIncreaseValueBy: 1))
        
        // then
        try getNotificationHaptics().verify_givenFeedback(.warning, .warning)
    }
    
    func test_panningOutsideRange_whenUserPansSeveralJumpsOverMinValueAndTurnsAround_shouldValueChangeAfterFirstJump() throws {
        // given
        sut.minMaxRange = 0 ... 10
        let pan = try preconfigure_beganPanning(initialValue: 0, jump: 1)
        
        // when
        pan.continuePanning(by: panTranslation(toIncreaseValueBy: -1))
        pan.continuePanning(by: panTranslation(toIncreaseValueBy: -1))
        pan.continuePanning(by: panTranslation(toIncreaseValueBy: -1))
        pan.continuePanning(by: panTranslation(toIncreaseValueBy: 1))
        
        // then
        XCTAssertEqual(sut.value, 1)
    }
    
    func test_panningOutsideRange_whenPansOverMinAndThenOverMax_shouldIgnoreOverscrollWhenGoingBack() throws {
        // given
        sut.minMaxRange = 0 ... 5
        let pan = try preconfigure_beganPanning(initialValue: 0, jump: 1)
        
        // when
        for _ in 0 ..< 3 {
            pan.continuePanning(by: panTranslation(toIncreaseValueBy: -1))
        }
        for _ in 0 ..< 10 {
            pan.continuePanning(by: panTranslation(toIncreaseValueBy: 1))
        }
        pan.continuePanning(by: panTranslation(toIncreaseValueBy: -1))
        
        // then
        XCTAssertEqual(sut.value, 4)
    }
    
    func test_panningOutsideRange_shouldNotTriggerExcesiveSelectionHaptics() throws {
        // given
        sut.minMaxRange = 0 ... 5
        let pan = try preconfigure_beganPanning(initialValue: 0, jump: 1)
        
        // when
        for _ in 0 ..< 3 {
            pan.continuePanning(by: panTranslation(toIncreaseValueBy: -1))
        }
        
        // then
        let haptics = try getSelectionHaptics()
        XCTAssertEqual(haptics.selectionChangedCallsCount, 0)
    }
    
    func test_panningOutsideRange_whenPanningCausesNegativeAndZeroChanges_shouldNotTriggerExcesiveWarningHaptics() throws {
        // given
        sut.minMaxRange = 0 ... 5
        let pan = try preconfigure_beganPanning(initialValue: 0, jump: 1)
        
        // when
        pan.continuePanning(by: panTranslation(toIncreaseValueBy: -1))
        pan.continuePanning(by: panTranslation(toIncreaseValueBy: 0))
        pan.continuePanning(by: panTranslation(toIncreaseValueBy: -1))
        
        // then
        let haptics = try getNotificationHaptics()
        XCTAssertEqual(haptics.receivedNotifications, [.warning])
    }
    
    func test_panningOutsideRange_whenJumpIsTooLargeToHitLowerLimit_shouldSetToLimit() throws {
        // given
        sut.minMaxRange = 0 ... 10
        let pan = try preconfigure_beganPanning(initialValue: 1, jump: 1)
        
        // when
        pan.continuePanning(by: panTranslation(toIncreaseValueBy: -2))
        
        // then
        XCTAssertEqual(sut.value, 0)
    }
    
    func test_panningOutsideRange_whenJumpIsTooLargeToHitUpperLimit_shouldSetToLimit() throws {
        // given
        sut.minMaxRange = 0 ... 10
        let pan = try preconfigure_beganPanning(initialValue: 9, jump: 1)
        
        // when
        pan.continuePanning(by: panTranslation(toIncreaseValueBy: 2))
        
        // then
        XCTAssertEqual(sut.value, 10)
    }
    
    func test_panningOutsideRange_whenJumpIsTooLargeToHitLowerLimitInTimeMode() throws {
        // given
        sut.mode = .time
        let pan = try preconfigure_beganPanning(initialValue: 1, jump: 1)
        
        // when
        pan.continuePanning(by: panTranslation(toIncreaseValueBy: -2))
        
        // then
        XCTAssertEqual(sut.value, nil)
    }
    
    func test_panningOutsideRange_whenJumpIsTooLargeToHitUpperLimitInTimeMode() throws {
        // given
        sut.mode = .time
        let pan = try preconfigure_beganPanning(initialValue: 598, jump: 1)
        
        // when
        pan.continuePanning(by: panTranslation(toIncreaseValueBy: 2))
        
        // then
        XCTAssertEqual(sut.value, 599)
    }
 
    func test_outOfRangeHaptics_whenUserPansOutOfRange_shouldNotDoSelectionFeedback() throws {
        // given
        sut.minMaxRange = 0 ... 100
        let pan = try preconfigure_beganPanning(initialValue: 100, jump: 1)
        
        // when
        pan.continuePanning(by: panTranslation(toIncreaseValueBy: 1))
        
        // then
        let haptics = try getSelectionHaptics()
        XCTAssertEqual(haptics.selectionChangedCallsCount, 0)
    }
    
    // MARK: - Time
    
    func test_timeFormatting_whenValueIsNil() {
        // given
        sut.mode = .time
        
        // then
        XCTAssertEqual(sut.textValue, "0:00")
    }
    
    func test_enteringTime_whenFirstDigitIsEntered() throws {
        // given
        try preconfigure_enteringTime()
        
        // when
        sut.insertText("1")
        
        // then
        XCTAssertEqual(sut.textValue, "0:01")
    }
    
    func test_enteringTime_whenSecondDigitIsEntered() throws {
        // given
        try preconfigure_enteringTime()
        
        // when
        sut.insertText("1")
        sut.insertText("2")
        
        // then
        XCTAssertEqual(sut.textValue, "0:12")
    }
    
    func test_enteringTime_whenThirdDigitIsEntered() throws {
        // given
        try preconfigure_enteringTime()
        
        // when
        sut.insertText("1")
        sut.insertText("2")
        sut.insertText("8")
        
        // then
        XCTAssertEqual(sut.textValue, "1:28")
    }
    
    func test_enteringTime_whenZeroAppearsInTheMiddle() throws {
        // given
        try preconfigure_enteringTime()
        
        // when
        sut.insertText("2")
        sut.insertText("0")
        sut.insertText("9")
        
        // then
        XCTAssertEqual(sut.textValue, "2:09")
    }
    
    func test_enteringTime_when9IsEnteredAsSecondNumber_shouldKeepSecondFormattingWhenEntering() throws {
        // given
        try preconfigure_enteringTime()
        
        // when
        sut.insertText("9")
        sut.insertText("0")
        
        // then
        XCTAssertEqual(sut.textValue, "0:90")
    }
    
    func test_enteringTime_when80SecondsIsEnteredAndResignsResponder_shouldReformatToMinutesAndSeconds() throws {
        // given
        try preconfigure_enteringTime()
        sut.insertText("8")
        sut.insertText("0")
        
        // when
        XCTAssertTrue(sut.resignFirstResponder())
        
        // then
        XCTAssertEqual(sut.textValue, "1:20")
    }
    
    func test_enteringTime_shouldUpdateValueWithEachKeystroke() throws {
        // given
        try preconfigure_enteringTime()
        
        // when
        sut.insertText("4")
        
        // then
        XCTAssertEqual(sut.value, 4)
    }
    
    func test_backspacingTime_whenAllDigitsAreEntered() throws {
        // given
        try preconfigure(timeEntered: "1", "3", "5")
        XCTAssertEqual(sut.textValue, "1:35")
        
        // when
        sut.deleteBackward()
        
        // then
        XCTAssertEqual(sut.textValue, "0:13")
    }
    
    func test_backspacingEntireTimeEntry() throws {
        // given
        try preconfigure(timeEntered: "8", "3", "9")
        
        // when
        for _ in 0 ..< 3 {
            sut.deleteBackward()
        }
        
        // then
        XCTAssertEqual(sut.textValue, "0:00")
        XCTAssertEqual(sut.value, nil)
    }
    
    func test_timeEnteringHaptics_whenUserTriesToEnterFourthNumber_shouldVibrate() throws {
        // given
        try preconfigure(timeEntered: "1", "1", "2")
        
        // when
        sut.insertText("1")
        
        // then
        try getNotificationHaptics().verify_givenFeedback(.warning)
    }
    
    func test_timeEnteringHaptics_whenUserTriesToBackspaceWhenNothingIsEntered_shouldVibrate() throws {
        // given
        try preconfigure_enteringTime()
        
        // when
        sut.deleteBackward()
        
        // then
        try getNotificationHaptics().verify_givenFeedback(.warning)
    }
    
    func test_timeLabelUpdating_whenValueIsUpdatedFromOutside_shouldUpdateLabel() {
        // given
        sut.mode = .time

        // when
        sut.value = 5

        // then
        XCTAssertEqual(sut.textValue, "0:05")
    }

    func test_panning_whenInTimeMode() throws {
        // given
        sut.mode = .time
        let pan = try preconfigure_beganPanning(initialValue: 1, jump: 1)

        // when
        pan.continuePanning(by: panTranslation(toIncreaseValueBy: 1))

        // then
        XCTAssertEqual(sut.textValue, "0:02")
    }
    
    func test_settingTimeExternally_whenLabelHasExcessFormattingAndIsExternallySetToSameValue_shouldKeepFormatting() throws {
        // given
        try preconfigure(timeEntered: "9", "5")
        XCTAssertEqual(sut.textValue, "0:95")
        
        // when
        sut.value = 95
        
        // then
        XCTAssertEqual(sut.textValue, "0:95")
    }
    
    private func preconfigure(timeEntered: String...) throws {
        try preconfigure_enteringTime()
        for digit in timeEntered {
            sut.insertText(digit)
        }
    }
    
    private func preconfigure_enteringTime() throws {
        sut.mode = .time
        try getTap().tap()
        XCTAssertTrue(sut.isFirstResponder)
    }
    
    private func preconfigure_enteringFloatingPoints() throws {
        sut.mode = .floatingPoint
        try getTap().tap()
        XCTAssertTrue(sut.isFirstResponder)
    }
    
    private func toggleFirstResponderState() throws {
        let wasFirstResponder = sut.isFirstResponder
        try getTap().tap()
        XCTAssertNotEqual(sut.isFirstResponder, wasFirstResponder)
    }
    
    private func preconfigure_beganPanning(
        initialValue: Double,
        jump: Double
    ) throws -> UIPanGestureRecognizerMock {
        sut.value = initialValue
        sut.jumpInterval = jump
        let pan = try getPan()
        pan.beginPanning()
        return pan
    }
    
    private func panTranslation(toIncreaseValueBy factor: CGFloat) -> CGPoint {
        let threshold = 7 as CGFloat
        return CGPoint(
            x: 0,
            y: -factor * threshold
        )
    }
    
    private func getPan() throws -> UIPanGestureRecognizerMock {
        return try panInjector.getOnlyAliveInstance()
    }
    
    private func getTap() throws -> UITapGestureRecognizerMock {
        return try tapInjector.getOnlyAliveInstance()
    }
    
    private func getSelectionHaptics() throws -> UISelectionFeedbackGeneratorMock {
        return try selectionHapticsInjector.getOnlyAliveInstance()
    }
    
    private func getNotificationHaptics() throws -> UINotificationFeedbackGeneratorMock {
        return try notificationHapticsInjector.getOnlyAliveInstance()
    }
}
