//
//  UIPacePicker.swift
//  Core
//
//  Created by Łukasz Kasperek on 18/04/2022.
//

import UIKit
import SwiftUI

class UIPacePicker: UIControl, UIKeyInput {
    struct InputState {
        var eccentric: Pace.Component?
        var isometric: Pace.Component?
        var concentric: Pace.Component?
        var startingPoint: Pace.Component?
    }
    
    var pace = InputState()
    private var cursor: Int = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    private var isBeingEdited = false {
        didSet {
            setNeedsLayout()
        }
    }
    
    private let labels = [UILabel(), UILabel(), UILabel(), UILabel()]
    private let imageViews: [UIImageView] = {
        let imageNames = [
            "arrow.down",
            "arrow.down.to.line",
            "arrow.up",
            "arrow.up.to.line"
        ]
        return imageNames.map {
            UIImageView(image: UIImage(systemName: $0))
        }
    }()
    private lazy var stackView = UIStackView(arrangedSubviews: labels)
    private let cursorView = UIView()
    
    override var tintColor: UIColor! {
        didSet {
            layer.borderColor = tintColor.cgColor
            cursorView.layer.borderColor = tintColor.cgColor
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    override var inputViewController: UIInputViewController? {
        keyboardController
    }
    private let keyboardController = PaceKeyboardController()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 72, height: 32)
    }
    
    override func layoutSubviews() {
        stackView.frame = bounds.insetBy(dx: 8, dy: 0)
        layoutCursor()
        layoutFrame()
        for (label, imageView) in zip(labels, imageViews) {
            imageView.frame = convert(label.frame, from: stackView)
        }
    }
    
    private func layoutCursor() {
        let shouldShow = labels.indices.contains(cursor) && isBeingEdited
        cursorView.isHidden = !shouldShow
        guard shouldShow else { return }
        let labelFrame = convert(labels[cursor].frame, from: stackView)
        cursorView.frame = CGRect(
            x: labelFrame.minX,
            y: labelFrame.maxY - 5,
            width: labelFrame.width,
            height: 2
        )
    }
    
    private func layoutFrame() {
        let shouldShow = labels.indices.contains(cursor) == false && isBeingEdited
        layer.borderWidth = shouldShow ? 2 : 0
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
    
    var keyboardType: UIKeyboardType = .numberPad
    
    // MARK: - UIKeyInput
    
    var hasText: Bool {
        return pace.eccentric != nil
        && pace.isometric != nil
        && pace.concentric != nil
        && pace.startingPoint != nil
    }
    
    func insertText(_ text: String) {
        guard text.utf16.count == 1 else { return }
        guard cursor < 4 else { return }
        guard let component = Pace.Component(textRepresentation: text) else { return }
        editValue {
            editPaceBasedOnCursor(component: component)
            cursor += 1
        }
    }
    
    private func editPaceBasedOnCursor(component: Pace.Component?) {
        switch cursor {
        case 0: pace.eccentric = component
        case 1: pace.isometric = component
        case 2: pace.concentric = component
        case 3: pace.startingPoint = component
        default:
            break
        }
    }
    
    private func editValue(process: () -> Void) {
        process()
        updateLabels()
        sendActions(for: .valueChanged)
    }
    
    private func updateLabels() {
        func update(
            at index: Int,
            with keyPath: KeyPath<InputState, Pace.Component?>
        ) {
            let paceString = pace[keyPath: keyPath].map(\.textRepresentation)
            labels[index].text = paceString
            imageViews[index].isHidden = paceString != nil
        }
        update(at: 0, with: \.eccentric)
        update(at: 1, with: \.isometric)
        update(at: 2, with: \.concentric)
        update(at: 3, with: \.startingPoint)
    }
    
    func deleteBackward() {
        guard cursor > 0 else { return }
        editValue {
            cursor -= 1
            editPaceBasedOnCursor(component: nil)
        }
    }
    
    // MARK: - Gesture Handling
    
    private let tap = metaUITapGestureRecognizer.init()
    
    @objc private func handleTap(sender: UITapGestureRecognizer) {
        if isFirstResponder {
            _ = resignFirstResponder()
        } else {
            _ = becomeFirstResponder()
        }
    }
    
    // MARK: - Setup
    
    private func setUp() {
        configureAutolayoutPriorities()
        addSubviews()
        configureStackView()
        configureImageViews()
        applyStyling()
        styleLabels()
        styleCursor()
        configureTap()
    }
    
    private func configureAutolayoutPriorities() {
        setContentHuggingPriority(.defaultHigh, for: .horizontal)
        setContentHuggingPriority(.defaultHigh, for: .vertical)
        setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
    }
    
    private func addSubviews() {
        addSubview(stackView)
        addSubview(cursorView)
        for label in labels {
            stackView.addArrangedSubview(label)
        }
        for imageView in imageViews {
            addSubview(imageView)
        }
    }
    
    private func configureStackView() {
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
    }
    
    private func configureImageViews() {
        for imageView in imageViews {
            imageView.contentMode = .scaleAspectFit
            imageView.tintColor = .systemFill
        }
    }
    
    private func applyStyling() {
        backgroundColor = .secondarySystemFill
        layer.cornerRadius = 8
        layer.masksToBounds = true
        layer.borderWidth = 0
        layer.borderColor = tintColor.cgColor
    }
    
    private func styleLabels() {
        for label in labels {
            label.textAlignment = .center
            label.font = UIFont.rounded(ofSize: 18, weight: .semibold)
        }
    }
    
    private func styleCursor() {
        cursorView.backgroundColor = tintColor
    }
    
    private func configureTap() {
        tap.addTarget(self, action: #selector(handleTap(sender:)))
        addGestureRecognizer(tap)
    }
}
