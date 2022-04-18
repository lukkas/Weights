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
    private var cursor: Int = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIKeyInput
    
    var hasText: Bool {
        return pace.eccentric != nil
        && pace.isometric != nil
        && pace.concentric != nil
        && pace.startingPoint != nil
    }
    
    func insertText(_ text: String) {
        guard let number = Int(text) else { return }
        editPaceBasedOnCursor(number: number)
        cursor += 1
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
    
    func deleteBackward() {
        guard cursor > 0 else { return }
        cursor -= 1
        editPaceBasedOnCursor(number: nil)
    }
}
