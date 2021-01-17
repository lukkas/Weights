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
            adoptToCurrentMode()
            updateLabel()
        }
    }
    var jumpInterval: Double? = 1
    var minMaxRange: Range<Double>? = 0 ..< 1000
    
    var value: Double? {
        didSet { updateLabel() }
    }
    var textValue: String { label.text ?? "" }
    
    private var isDecimalSeparatorLastEntered = false
    private var isBeingEdited = false {
        didSet { adjustBorder() }
    }
    private var timeEditor: TimeEditor?
    private let label = UILabel()
    
    private let formatter = NumberFormatter()
    lazy var themeColor: UIColor = tintColor {
        didSet { layer.borderColor = themeColor.cgColor }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
        adoptToCurrentMode()
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
            if mode == .time {
                timeEditor = TimeEditor(value: value)
            }
        }
        return hasBecome
    }
    
    override func resignFirstResponder() -> Bool {
        let didResign = super.resignFirstResponder()
        if didResign {
            isBeingEdited = false
            if let editor = timeEditor {
                editor.reformatComponents()
                label.text = editor.getFormattedText()
                timeEditor = nil
            } else if isDecimalSeparatorLastEntered {
                isDecimalSeparatorLastEntered = false
                updateLabel()
            }
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
        switch mode {
        case .wholes, .floatingPoint:
            label.text = value.map(getFormattedNumberText(from:))
        case .time:
            label.text = (timeEditor ?? TimeEditor(value: value)).getFormattedText()
        }
    }
    
    // MARK: UIKeyInput
    
    var hasText: Bool {
        return value != nil
    }
    
    func insertText(_ text: String) {
        switch mode {
        case .floatingPoint, .wholes:
            let currentText = value.map(getFormattedNumberText(from:)) ?? ""
            setValue(withText: currentText + text)
        case .time:
            guard let editor = timeEditor else { return }
            do {
                try editor.insert(text)
                value = editor.value
            } catch {
                notificationHaptics.notificationOccurred(.warning)
            }
        }
    }
    
    func deleteBackward() {
        switch mode {
        case .floatingPoint, .wholes:
            let currentText = value.map(getFormattedNumberText(from:)) ?? ""
            setValue(withText: String(currentText.dropLast()))
        case .time:
            guard let editor = timeEditor else { return }
            do {
                try editor.deleteBackward()
                value = editor.value
            } catch {
                notificationHaptics.notificationOccurred(.warning)
            }
        }
    }
    
    private func getFormattedNumberText(from value: Double) -> String {
        guard let formatted = formatter.string(from: NSNumber(value: value)) else { return "" }
        let result = isDecimalSeparatorLastEntered
            ? formatted + formatter.decimalSeparator!
            : formatted
        return result
    }
    
    private func setValue(withText text: String) {
        let valueCandidate = formatter.number(from: text)?.doubleValue
        guard validateValue(valueCandidate) else {
            notificationHaptics.notificationOccurred(.warning)
            return
        }
        isDecimalSeparatorLastEntered = text.last.map(String.init) == formatter.decimalSeparator
            && mode == .floatingPoint
        value = valueCandidate
        sendActions(for: .valueChanged)
    }
    
    private func validateValue(_ valueCandidate: Double?) -> Bool {
        guard let value = valueCandidate else { return true }
        guard let validationRange = minMaxRange else { return true }
        return validationRange.contains(value)
    }
    
    // MARK: - UITextInputTraits
    
    private func adoptToCurrentMode() {
        switch mode {
        case .wholes:
            keyboardType = .numberPad
            formatter.minimumSignificantDigits = 0
        case .floatingPoint:
            keyboardType = .decimalPad
            formatter.minimumSignificantDigits = 1
        case .time:
            keyboardType = .numberPad
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
        let valueBefore: Double?
        var translationRemainder: CGFloat
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
            panningState = .init(valueBefore: value, translationRemainder: 0)
            selectionHaptics.prepare()
        case .changed:
            guard var panningState = panningState else { return }
            let valueChange = consumePan(sender, panningState: &panningState)
            self.panningState = panningState
            do {
                value = try newValue(for: valueChange)
                errorHapticsRun = false
                if valueChange != 0 {
                    selectionHaptics.selectionChanged()
                }
            } catch {
                if errorHapticsRun { return }
                errorHapticsRun = true
                notificationHaptics.notificationOccurred(.warning)
            }
        case .ended:
            panningState = nil
        case .cancelled:
            value = panningState?.valueBefore
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
        defer { pan.setTranslation(.zero, in: self) }
        let translation = pan.translation(in: self).y + panningState.translationRemainder
        let singleJumpThreshold = 7 as Double
        let numberOfJumps = floor(Double(-translation) / singleJumpThreshold)
        let remainder = translation.remainder(dividingBy: CGFloat(singleJumpThreshold))
        panningState.translationRemainder = remainder
        return numberOfJumps * jumpInterval!
    }
    
    private func newValue(for valueChange: Double) throws -> Double {
        let valueCandidate = (panningState?.valueBefore ?? 0) + valueChange
        if let range = minMaxRange, range.contains(valueCandidate) == false {
            throw ValueOutOfRangeError()
        }
        return valueCandidate
    }
}

private struct ValueOutOfRangeError: Error {}

private class NumberEditor {
    
}

private class TimeEditor {
    private var components: [Double] = []
    private let maximumValue: Double = 599 // 9:59
    
    init(value: Double?) {
        setComponents(for: value)
    }
    
    var value: Double? {
        get { getValue() }
        set { setComponents(for: newValue) }
    }
    
    func getFormattedText() -> String {
        var result = components.alignedWithZeros(3)
            .map({ String(format: "%.0f", $0) })
            .joined()
        result.insert(":", at: result.index(after: result.startIndex))
        return result
    }
    
    func reformatComponents() {
        setComponents(for: value)
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
