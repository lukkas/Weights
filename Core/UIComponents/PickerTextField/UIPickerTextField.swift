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
    var minMaxRange: ClosedRange<Double>? {
        didSet { resetEditor() }
    }
    
    var value: Double? {
        get { editor.value }
        set {
            guard newValue != editor.value else { return }
            try? editor.setValue(newValue, allowReachingLimit: false)
            updateLabel()
        }
    }
    var textValue: String { label.text ?? "" }
    
    private var isBeingEdited = false {
        didSet { adjustBorder(animated: true) }
    }
    private var editor: Editing!
    private var resettingDrawerProgress: CGFloat = 0
    private let label = UILabel()
    private let resettingDrawer = UIResetValueDrawer()
    
    var borderColor: UIColor? {
        didSet {
            adjustBorder(animated: false)
        }
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
        resettingDrawer.frame = calculateDrawerFrame(forProgress: resettingDrawerProgress)
    }
    
    private enum DrawerAnimationType {
        case confirm, cancel
    }
    private func animateResettingDrawerToNeutralPosition(animationType: DrawerAnimationType) {
        UIView.animate(
            withDuration: 0.15,
            delay: 0,
            options: [.beginFromCurrentState, .curveEaseInOut],
            animations: { [self] in
            switch animationType {
            case .confirm:
                resettingDrawer.alpha = 0
            case .cancel:
                resettingDrawer.frame = calculateDrawerFrame(forProgress: resettingDrawerProgress)
            }
            },
            completion: { [self] _ in
            switch animationType {
            case .confirm:
                resettingDrawer.alpha = 1
                resettingDrawer.frame = calculateDrawerFrame(forProgress: resettingDrawerProgress)
            case .cancel: break
            }
        })
    }
    
    private func calculateDrawerFrame(forProgress progress: CGFloat) -> CGRect {
        let offsetProgress = max(0.9 - progress, 0)
            .scaled(from: 0 ..< 0.9, to: 0 ..< 1)
        let insetProgress = max(progress - 0.9, 0)
        let offset = offsetProgress * bounds.width
        let inset = insetProgress.scaled(from: 0 ..< 0.1, to: 0 ..< 3, invert: true)
        return bounds
            .insetBy(dx: inset, dy: inset)
            .offsetBy(dx: offset, dy: 0)
    }
    
    private func adjustBorder(animated: Bool) {
        let shouldHighlightBorder = isBeingEdited || panningState is ValueSteppingPanner
        let color = shouldHighlightBorder ? tintColor : borderColor
        let borderWidth: CGFloat = shouldHighlightBorder || borderColor != nil ? 2 : 0
        let adjustment = { [layer] in
            layer.borderColor = color?.cgColor
            layer.borderWidth = borderWidth
        }
        if animated {
            UIView.animateKeyframes(
                withDuration: 0.15,
                delay: 0,
                options: [.beginFromCurrentState],
                animations: adjustment,
                completion: nil
            )
        } else {
            adjustment()
        }
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
            haptics.wallHit(ignoreBlockade: true)
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
        addResettingDrawer()
        configureGestures()
    }
    
    private func configureAutolayoutPriorities() {
        setContentHuggingPriority(.defaultHigh, for: .horizontal)
        setContentHuggingPriority(.defaultHigh, for: .vertical)
        setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
    }
    
    private func applyStyling() {
        backgroundColor = .secondarySystemFill
        layer.cornerRadius = 8
        layer.masksToBounds = true
        layer.borderWidth = 0
    }
    
    private func addLabel() {
        addSubview(label)
        label.textAlignment = .center
        label.font = UIFont.rounded(ofSize: 18, weight: .semibold)
    }
    
    private func addResettingDrawer() {
        addSubview(resettingDrawer)
        resettingDrawer.layer.cornerRadius = 6
        resettingDrawer.layer.masksToBounds = true
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
    
    private var panningState: Panning? {
        didSet {
            if oldValue == nil || panningState == nil {
                adjustBorder(animated: true)
            }
        }
    }
    private var haptics = Haptics()
    
    @objc private func handlePan(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began:
            panningState = tryToCreatePanner(for: sender)
            haptics.prepare()
        case .changed:
            if panningState == nil {
                panningState = tryToCreatePanner(for: sender)
            }
            panningState?.consume(pan, relativelyTo: self)
        case .ended:
            panningState?.commit()
            panningState = nil
        case .cancelled:
            panningState?.cancel()
            panningState = nil
        default: break
        }
    }
    
    private func tryToCreatePanner(for pan: UIPanGestureRecognizer) -> Panning? {
        let translation = pan.translation(in: self)
        if abs(translation.y) > abs(translation.x) {
            return newValueSteppingPanner()
        }
        if abs(translation.x) > abs(translation.y) && value != nil {
            return newValueResettingPanner()
        }
        return nil
    }
    
    private func newValueSteppingPanner() -> Panning {
        ValueSteppingPanner(
            editor: editor,
            jumpInterval: jumpInterval!,
            onValueUpdated: {
                self.updateLabel()
                self.haptics.selection()
            },
            onWallHit: {
                self.haptics.wallHit()
            },
            onValueCommited: {
                self.sendActions(for: .valueChanged)
            }
        )
    }
    
    private func newValueResettingPanner() -> Panning {
        ValueResettingPanner(onValueUpdated: { [weak self] update in
            switch update {
            case let .gradual(drawerProgress):
                self?.resettingDrawerProgress = drawerProgress
                if drawerProgress == 1 {
                    self?.haptics.success()
                }
                self?.setNeedsLayout()
            case .cancel:
                self?.resettingDrawerProgress = 0
                self?.animateResettingDrawerToNeutralPosition(animationType: .cancel)
            case .commit:
                self?.value = nil
                self?.resettingDrawerProgress = 0
                self?.animateResettingDrawerToNeutralPosition(animationType: .confirm)
            }
        })
    }
}

private struct ValueOutOfRangeError: Error {}

private struct Haptics {
    private let selectionHaptics = metaUISelectionFeedbackGenerator.init()
    private let notificationHaptics = metaUINotificationFeedbackGenerator.init()
    private var repeatedErrorsBlockade = false
    
    mutating func prepare() {
        selectionHaptics.prepare()
        repeatedErrorsBlockade = false
    }
    
    mutating func selection() {
        if repeatedErrorsBlockade == true {
            repeatedErrorsBlockade = false
        }
        selectionHaptics.selectionChanged()
    }
    
    func success() {
        notificationHaptics.notificationOccurred(.success)
    }
    
    mutating func wallHit(ignoreBlockade: Bool = false) {
        if ignoreBlockade {
            notificationHaptics.notificationOccurred(.warning)
        } else if repeatedErrorsBlockade == false {
            repeatedErrorsBlockade = true
            notificationHaptics.notificationOccurred(.warning)
        }
    }
}

private protocol Panning {
    mutating func consume(
        _ pan: UIPanGestureRecognizer,
        relativelyTo view: UIView
    )
    func cancel()
    func commit()
}

private struct ValueSteppingPanner: Panning {
    private let editor: Editing
    private let onValueUpdated: () -> Void
    private let onValueCommited: () -> Void
    private let onWallHit: () -> Void
    private let jumpInterval: Double
    private let originalValue: Double?
    private(set) var jumps: Double = 0
    private(set) var unconsumedJumps: Double = 0
    
    init(
        editor: Editing,
        jumpInterval: Double,
        onValueUpdated: @escaping () -> Void,
        onWallHit: @escaping () -> Void,
        onValueCommited: @escaping () -> Void
    ) {
        self.editor = editor
        self.jumpInterval = jumpInterval
        self.originalValue = editor.value
        self.onValueUpdated = onValueUpdated
        self.onWallHit = onWallHit
        self.onValueCommited = onValueCommited
    }
    
    mutating func consume(
        _ pan: UIPanGestureRecognizer,
        relativelyTo view: UIView
    ) {
        let translation = pan.translation(in: view)
        let singleJumpThreshold = 10 as Double
        let numberOfJumps = floor(Double(-translation.y) / singleJumpThreshold)
        let offsetNumberOfJumps = numberOfJumps - unconsumedJumps
        let valueChange = offsetNumberOfJumps * jumpInterval
        do {
            try editor.setValue((originalValue ?? 0) + valueChange, allowReachingLimit: true)
            let didUpdate = update(withConsumedJumps: numberOfJumps)
            if didUpdate {
                onValueUpdated()
            }
        } catch {
            update(withUnconsumedJumps: numberOfJumps)
            onWallHit()
        }
    }
    
    func cancel() {
        try? editor.setValue(originalValue, allowReachingLimit: true)
    }
    
    func commit() {
        let valueWasChanged = editor.value != originalValue
        if valueWasChanged {
            onValueCommited()
        }
    }
    
    private mutating func update(withConsumedJumps newJumps: Double) -> Bool {
        let didUpdate = newJumps != jumps
        jumps = newJumps
        return didUpdate
    }
    
    private mutating func update(withUnconsumedJumps newJumps: Double) {
        unconsumedJumps += newJumps - jumps
        jumps = newJumps
    }
}

private struct ValueResettingPanner: Panning {
    enum ValueUpdate {
        case gradual(CGFloat)
        case commit
        case cancel
    }
    
    private let onValueUpdated: (ValueUpdate) -> Void
    private let translationToComplete = 50 as CGFloat
    private var currentValue: CGFloat = 0
    
    init(onValueUpdated: @escaping (ValueUpdate) -> Void) {
        self.onValueUpdated = onValueUpdated
    }
    
    mutating func consume(
        _ pan: UIPanGestureRecognizer,
        relativelyTo view: UIView
    ) {
        let translation = pan.translation(in: view)
        let fractionCompleted = (-translation.x / translationToComplete)
            .clamped(to: 0 ... 1)
        if currentValue != fractionCompleted {
            currentValue = fractionCompleted
            onValueUpdated(.gradual(fractionCompleted))
        }
    }
    
    func cancel() {
        onValueUpdated(.cancel)
    }
    
    func commit() {
        onValueUpdated(currentValue == 1 ? .commit : .cancel)
    }
}

private protocol Editing {
    var value: Double? { get }
    func setValue(_ newValue: Double?, allowReachingLimit: Bool) throws
    func insert(_ insertion: String) throws
    func deleteBackward() throws
    func getFormattedText() -> String
    func closeEditingSession()
}

private class NumberEditor: Editing {
    private let formatter = NumberFormatter()
    private let decimalMode: Bool
    private let minMaxRange: ClosedRange<Double>?
    private var isDecimalSeparatorLastEntered = false
    
    private(set) var value: Double?
    
    init(
        value: Double?,
        decimalMode: Bool,
        minMaxRange: ClosedRange<Double>?
    ) {
        self.value = value
        self.decimalMode = decimalMode
        self.minMaxRange = minMaxRange
        formatter.minimumSignificantDigits = decimalMode ? 1 : 0
    }
    
    func setValue(_ newValue: Double?, allowReachingLimit: Bool) throws {
        guard let range = minMaxRange, let unwrappedValue = newValue else {
            value = newValue; return
        }
        if range.contains(unwrappedValue) {
            value = newValue; return
        }
        if allowReachingLimit == false {
            throw ValueOutOfRangeError()
        }
        guard let currentValue = value else {
            throw ValueOutOfRangeError()
        }
        if currentValue > range.lowerBound && unwrappedValue < currentValue {
            value = range.lowerBound; return
        }
        if currentValue < range.upperBound && unwrappedValue > currentValue {
            value = range.upperBound; return
        }
        throw ValueOutOfRangeError()
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
    
    func setValue(_ newValue: Double?, allowReachingLimit: Bool) throws {
        guard let newValue = newValue else {
            setComponents(for: nil); return
        }
        if allowedRange.contains(newValue) {
            setComponents(for: newValue); return
        }
        if allowReachingLimit == false {
            throw ValueOutOfRangeError()
        }
        guard let currentValue = value else {
            throw ValueOutOfRangeError()
        }
        if currentValue > allowedRange.lowerBound && newValue < currentValue {
            setComponents(for: allowedRange.lowerBound); return
        }
        if currentValue < allowedRange.upperBound && newValue > currentValue {
            setComponents(for: allowedRange.upperBound); return
        }
        throw ValueOutOfRangeError()
    }
    
    private var allowedRange: ClosedRange<Double> { 0 ... maximumValue }
    
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
