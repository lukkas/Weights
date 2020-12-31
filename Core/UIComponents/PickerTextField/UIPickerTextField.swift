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
        case wholes, floatingPoint
    }
    
    var jumpInterval: Double? = 1
    var mode: Mode = .wholes {
        didSet {
            adoptToCurrentMode()
        }
    }
    
    var value: Double? {
        didSet {
            label.text = getCurrentTextValue()
        }
    }
    var textValue: String {
        return getCurrentTextValue()
    }
    private var isDecimalSeparatorLastEntered = false
    private var isBeingEdited = false {
        didSet { adjustBorder() }
    }
    private var isBeingPannedOn = false {
        didSet { adjustBorder() }
    }
    private let label = UILabel()
    
    private let formatter = NumberFormatter()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
        adoptToCurrentMode()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) { fatalError("Storyboards are not compatible with truth and beauty") }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 50, height: 44)
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
        }
        return didResign
    }
    
    override func layoutSubviews() {
        label.frame = bounds
    }
    
    private func adjustBorder() {
        let shouldHighlightBorder = isBeingEdited || isBeingPannedOn
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
    
    // MARK: UIKeyInput
    
    var hasText: Bool {
        return value != nil
    }
    
    func insertText(_ text: String) {
        let currentText = getCurrentTextValue()
        setValue(withText: currentText + text)
    }
    
    private func getCurrentTextValue() -> String {
        guard let value = value else { return "" }
        guard let formatted = formatter.string(from: NSNumber(value: value)) else { return "" }
        let result = isDecimalSeparatorLastEntered
            ? formatted + formatter.decimalSeparator!
            : formatted
        return result
    }
    
    private func setValue(withText text: String) {
        isDecimalSeparatorLastEntered = text.last.map(String.init) == formatter.decimalSeparator
            && mode == .floatingPoint
        value = formatter.number(from: text)?.doubleValue
        sendActions(for: .valueChanged)
    }
    
    func deleteBackward() {
        let currentText = getCurrentTextValue()
        setValue(withText: String(currentText.dropLast()))
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
        layer.borderColor = tintColor.cgColor
    }
    
    private func addLabel() {
        addSubview(label)
        label.textAlignment = .center
        label.font = UIFont.rounded(ofSize: 18, weight: .semibold)
    }
    
    private let tap = UITapGestureRecognizer()
    private let pan = UIPanGestureRecognizer()
    
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
    
    private var valueWhenGestureBegan: Double?
    private var previousNumberOfJumps: Double?
    private let panJumpThreshold: CGFloat = 7
    private let hapticsGenerator = UISelectionFeedbackGenerator()
    
    @objc private func handlePan(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began:
            valueWhenGestureBegan = value
            previousNumberOfJumps = 0
            isBeingPannedOn = true
            hapticsGenerator.prepare()
        case .changed:
            let translation = sender.translation(in: self).y
            let numberOfJumps = Double(floor(-translation / panJumpThreshold))
            if numberOfJumps != previousNumberOfJumps {
                hapticsGenerator.selectionChanged()
            }
            previousNumberOfJumps = numberOfJumps
            let valueChange = numberOfJumps * jumpInterval!
            value = (valueWhenGestureBegan ?? 0) + valueChange
        case .ended:
            valueWhenGestureBegan = nil
            previousNumberOfJumps = nil
            isBeingPannedOn = false
        case .cancelled:
            value = valueWhenGestureBegan
            valueWhenGestureBegan = nil
            previousNumberOfJumps = nil
            isBeingPannedOn = false
        default: break
        }
    }
}
