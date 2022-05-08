//
//  UIPacePicker.swift
//  Core
//
//  Created by Łukasz Kasperek on 18/04/2022.
//

import UIKit

class UIPacePicker: UIControl, UIKeyInput {
    struct Pace {
        var eccentric: Int?
        var isometric: Int?
        var concentric: Int?
        var startingPoint: Int?
    }
    
    var pace = Pace()
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
        didSet { cursorView.layer.borderColor = tintColor.cgColor }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 72, height: 32)
    }
    
    override func layoutSubviews() {
        stackView.frame = bounds.insetBy(dx: 8, dy: 0)
        layoutCursor()
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
        guard let number = Int(text) else { return }
        editValue {
            editPaceBasedOnCursor(number: number)
            cursor += 1
        }
    }
    
    private func editPaceBasedOnCursor(number: Int?) {
        switch cursor {
        case 0: pace.eccentric = number
        case 1: pace.isometric = number
        case 2: pace.concentric = number
        case 3: pace.startingPoint = number
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
            with keyPath: KeyPath<Pace, Int?>
        ) {
            let paceString = pace[keyPath: keyPath].map(String.init)
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
            editPaceBasedOnCursor(number: nil)
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
