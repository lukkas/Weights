//
//  Publishers+Keyboard.swift
//  Core
//
//  Created by Łukasz Kasperek on 02/05/2020.
//  Copyright © 2020 Łukasz Kasperek. All rights reserved.
//

import Combine
import Foundation
import UIKit

extension Publishers {
    static var keyboardHeight: AnyPublisher<CGFloat, Never> {
        let willShow = NotificationCenter.default
            .publisher(for: UIApplication.keyboardWillShowNotification)
            .map { $0.keyboardHeight }
        let willHide = NotificationCenter.default
            .publisher(for: UIApplication.keyboardWillHideNotification)
            .map { _ in CGFloat(0) }
        return MergeMany(willShow, willHide)
            .eraseToAnyPublisher()
    }
}

private extension Notification {
    var keyboardHeight: CGFloat {
        let frame = userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        return frame?.height ?? 0
    }
}
