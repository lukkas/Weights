//
//  PickerTextField.swift
//  Core
//
//  Created by Łukasz Kasperek on 29/12/2020.
//  Copyright © 2020 Łukasz Kasperek. All rights reserved.
//

import Foundation
import SwiftUI
import UIKit

class UIPickerTextField: UIControl, UIKeyInput, UIGestureRecognizerDelegate {
    enum Mode {
        case wholes, floatingPoint, time
    }
    
    var mode: Mode = .wholes {
        didSet {
            updateKeyboardTypeForCurrentMode()
            resetEditor()
            updateLabel()
        }
    }
    var jumpInterval: Double? = 1
    var minMaxRange: Range<Double>? {
        didSet { resetEditor() }
    }
    
    var value: Double? {
        get { editor.value }
        set {
            guard newValue != editor.value else { return }
            try? editor.setValue(newValue)
            updateLabel()
        }
    }
    var textValue: String { label.text ?? "" }
    
    private var isBeingEdited = false {
        didSet { adjustBorder() }
    }
    private var editor: Editing!
    private let label = UILabel()
    
    lazy var themeColor: UIColor = tintColor {
        didSet { layer.borderColor = themeColor.cgColor }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
        updateKeyboardTypeForCurrentMode()
        resetEditor()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) { fatalError("Storyboards are not compatible with truth and beauty") }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 50, height: 36)
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func becomeFirstResponder() -> Bool {
        let hasBecome = super.becomeFirstResponder()
        if hasBecome {
            isBeingEdited = true
        }
        return hasBecome
    }
    
    override func resignFirstResponder() -> Bool {
        let didResign = super.resignFirstResponder()
        if didResign {
            isBeingEdited = false
            editor.closeEditingSession()
            updateLabel()
        }
        return didResign
    }
    
    override func layoutSubviews() {
        label.frame = bounds
    }
    
    private func adjustBorder() {
        let shouldHighlightBorder = isBeingEdited || panningState != nil
        UIView.animateKeyframes(
            withDuration: 0.15,
            delay: 0,
            options: [.beginFromCurrentState],
            animations: {
                self.layer.borderWidth = shouldHighlightBorder ? 2 : 0
            },
            completion: nil
        )
    }
    
    private func updateLabel() {
        label.text = editor.getFormattedText()
    }
    
    // MARK: UIKeyInput
    
    var hasText: Bool {
        return value != nil
    }
    
    func insertText(_ text: String) {
        editValue {
            try editor.insert(text)
        }
    }
    
    func deleteBackward() {
        editValue {
            try editor.deleteBackward()
        }
    }
    
    private func editValue(process: () throws -> Void) {
        do {
            try process()
            updateLabel()
            sendActions(for: .valueChanged)
        } catch {
            notificationHaptics.notificationOccurred(.warning)
        }
    }
    
    private func validateValue(_ valueCandidate: Double?) -> Bool {
        guard let value = valueCandidate else { return true }
        guard let validationRange = minMaxRange else { return true }
        return validationRange.contains(value)
    }
    
    // MARK: - UITextInputTraits
    
    private func updateKeyboardTypeForCurrentMode() {
        switch mode {
        case .wholes, .time: keyboardType = .numberPad
        case .floatingPoint: keyboardType = .decimalPad
        }
    }
    
    private func resetEditor() {
        switch mode {
        case .wholes:
            editor = NumberEditor(value: editor?.value, decimalMode: false, minMaxRange: minMaxRange)
        case .floatingPoint:
            editor = NumberEditor(value: editor?.value, decimalMode: true, minMaxRange: minMaxRange)
        case .time:
            editor = TimeEditor(value: editor?.value)
        }
    }
    
    var keyboardType: UIKeyboardType = .numberPad
    
    // MARK: - Setup
    
    private func setUp() {
        configureAutolayoutPriorities()
        applyStyling()
        addLabel()
        configureGestures()
    }
    
    private func configureAutolayoutPriorities() {
        setContentHuggingPriority(.defaultHigh, for: .horizontal)
        setContentHuggingPriority(.defaultHigh, for: .vertical)
        setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
    }
    
    private func applyStyling() {
        backgroundColor = .systemFill
        layer.cornerRadius = 8
        layer.masksToBounds = true
        layer.borderWidth = 0
        layer.borderColor = themeColor.cgColor
    }
    
    private func addLabel() {
        addSubview(label)
        label.textAlignment = .center
        label.font = UIFont.rounded(ofSize: 18, weight: .semibold)
    }
    
    private let tap = metaUITapGestureRecognizer.init()
    private let pan = metaUIPanGestureRecognizer.init()
    
    private func configureGestures() {
        tap.addTarget(self, action: #selector(handleTap(sender:)))
        pan.addTarget(self, action: #selector(handlePan(sender:)))
        pan.delegate = self
        addGestureRecognizer(tap)
        addGestureRecognizer(pan)
    }
    
    // MARK: - UIGestureRecognizerDelegate
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer === pan {
            return jumpInterval != nil
        }
        return true
    }
    
    // MARK: - Gesture Handling
    
    @objc private func handleTap(sender: UITapGestureRecognizer) {
        if isFirstResponder {
            _ = resignFirstResponder()
        } else {
            _ = becomeFirstResponder()
        }
    }
    
    private struct PanningState {
        let originalValue: Double?
        private(set) var jumps: Double = 0
        private(set) var didChangeInLastIteration = false
        
        mutating func update(jumps newJumps: Double) {
            didChangeInLastIteration = newJumps != jumps
            jumps = newJumps
        }
    }
    
    private var panningState: PanningState? {
        didSet {
            if oldValue == nil || panningState == nil {
                adjustBorder()
            }
        }
    }
    private var errorHapticsRun = false
    private let selectionHaptics = metaUISelectionFeedbackGenerator.init()
    private let notificationHaptics = metaUINotificationFeedbackGenerator.init()
    
    @objc private func handlePan(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began:
            panningState = .init(originalValue: value)
            selectionHaptics.prepare()
        case .changed:
            guard var panningState = panningState else { return }
            let valueChange = consumePan(sender, panningState: &panningState)
            self.panningState = panningState
            do {
                let valueCandidate = (panningState.originalValue ?? 0) + valueChange
                try mutateValueForPanning(valueCandidate)
                errorHapticsRun = false
                if panningState.didChangeInLastIteration {
                    selectionHaptics.selectionChanged()
                }
            } catch {
                if errorHapticsRun { return }
                errorHapticsRun = true
                notificationHaptics.notificationOccurred(.warning)
            }
        case .ended:
            let didChangeValue = value != panningState?.originalValue
            panningState = nil
            if didChangeValue {
                sendActions(for: .valueChanged)
            }
        case .cancelled:
            try? mutateValueForPanning(panningState?.originalValue)
            panningState = nil
        default: break
        }
    }
    
    private func getNumberOfValueJumps(for translation: CGPoint) -> Double {
        let singleJumpThreshold = 7 as CGFloat
        return Double(floor(-translation.y / singleJumpThreshold))
    }
    
    private func consumePan(
        _ pan: UIPanGestureRecognizer,
        panningState: inout PanningState
    ) -> Double {
        let translation = pan.translation(in: self).y
        let singleJumpThreshold = 7 as Double
        let numberOfJumps = floor(Double(-translation) / singleJumpThreshold)
        panningState.update(jumps: numberOfJumps)
        return numberOfJumps * jumpInterval!
    }
    
    private func mutateValueForPanning(_ newValue: Double?) throws {
        try editor.setValue(newValue)
        updateLabel()
    }
}

private struct ValueOutOfRangeError: Error {}

private protocol Editing {
    var value: Double? { get }
    func setValue(_ newValue: Double?) throws
    func insert(_ insertion: String) throws
    func deleteBackward() throws
    func getFormattedText() -> String
    func closeEditingSession()
}

private class NumberEditor: Editing {
    private let formatter = NumberFormatter()
    private let decimalMode: Bool
    private let minMaxRange: Range<Double>?
    private var isDecimalSeparatorLastEntered = false
    
    private(set) var value: Double?
    
    init(
        value: Double?,
        decimalMode: Bool,
        minMaxRange: Range<Double>?
    ) {
        self.value = value
        self.decimalMode = decimalMode
        self.minMaxRange = minMaxRange
        formatter.minimumSignificantDigits = decimalMode ? 1 : 0
    }
    
    func setValue(_ newValue: Double?) throws {
        if
            let range = minMaxRange,
            let newValue = newValue,
            range.contains(newValue) == false {
            throw ValueOutOfRangeError()
        }
        value = newValue
    }
    
    func closeEditingSession() {
        isDecimalSeparatorLastEntered = false
    }
    
    func insert(_ insertion: String) throws {
        let currentText = getFormattedText()
        value = try getValue(forText: currentText + insertion)
    }
    
    func deleteBackward() throws {
        let currentText = getFormattedText()
        if currentText.isEmpty {
            throw ValueOutOfRangeError()
        }
        value = try getValue(forText: String(currentText.dropLast()))
    }
    
    func getFormattedText() -> String {
        guard let value = value else { return "" }
        guard let formatted = formatter.string(from: NSNumber(value: value)) else { return "" }
        let result = isDecimalSeparatorLastEntered
            ? formatted + formatter.decimalSeparator!
            : formatted
        return result
    }
    
    private func getValue(forText text: String) throws -> Double? {
        let valueCandidate = formatter.number(from: text)?.doubleValue
        guard validateValue(valueCandidate) else {
            throw ValueOutOfRangeError()
        }
        isDecimalSeparatorLastEntered = decimalMode && text.last.map(String.init) == formatter.decimalSeparator
        return valueCandidate
    }
    
    private func validateValue(_ valueCandidate: Double?) -> Bool {
        guard let value = valueCandidate else { return true }
        guard let validationRange = minMaxRange else { return true }
        return validationRange.contains(value)
    }
}

private class TimeEditor: Editing {
    private var components: [Double] = []
    private let maximumValue: Double = 599 // 9:59
    
    init(value: Double?) {
        setComponents(for: value)
    }
    
    var value: Double? { getValue() }
    
    func setValue(_ newValue: Double?) throws {
        if
            let newValue = newValue,
            (0 ... maximumValue).contains(newValue) == false {
            throw ValueOutOfRangeError()
        }
        setComponents(for: newValue)
    }
    
    func getFormattedText() -> String {
        var result = components.alignedWithZeros(3)
            .map({ String(format: "%.0f", $0) })
            .joined()
        result.insert(":", at: result.index(after: result.startIndex))
        return result
    }
    
    func closeEditingSession() {
        func reformatComponents() {
            setComponents(for: value)
        }
        reformatComponents()
    }
    
    private func setComponents(for value: Double?) {
        if let value = value, value > 0 {
            let limitedValue = min(value, maximumValue)
            components = extractComponents(fromNonZeroValue: limitedValue)
        } else {
            components = []
        }
    }
    
    private func extractComponents(fromNonZeroValue value: Double) -> [Double] {
        var components = [Double]()
        let singles = value.truncatingRemainder(dividingBy: 10)
        let secondsLeft = value - singles
        components.insert(singles, at: 0)
        if secondsLeft == 0 { return components }
        let (minutes, remainder) = secondsLeft.quotientAndRemainder(divdingBy: 60)
        components.insert(remainder / 10, at: 0)
        if minutes == 0 { return components }
        components.insert(minutes, at: 0)
        return components
    }
    
    private func getValue() -> Double? {
        var components = self.components
        var result: Double?
        var multipliers = [60, 10, 1] as [Double]
        while
            let component = components.popLast(),
            let multiplier = multipliers.popLast() {
            result = (result ?? 0) + component * multiplier
        }
        return result
    }
    
    func insert(_ stringComponent: String) throws {
        guard let number = Double(stringComponent), components.count < 3 else {
            throw ValueOutOfRangeError()
        }
        components.append(number)
    }
    
    func deleteBackward() throws {
        let popped = components.popLast()
        if popped == nil {
            throw ValueOutOfRangeError()
        }
    }
}

private extension Double {
    func quotientAndRemainder(divdingBy divider: Double) -> (Double, Double) {
        return (
            (self / divider).rounded(.down),
            truncatingRemainder(dividingBy: divider)
        )
    }
}

private extension Array where Element == Double {
    func alignedWithZeros(_ numberOfZeroes: Int) -> [Double] {
        var mutableCopy = self
        while mutableCopy.count < numberOfZeroes {
            mutableCopy.insert(0, at: 0)
        }
        return mutableCopy
    }
}
