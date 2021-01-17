//
//  UINotificationFeedbackGeneratorMock.swift
//  CoreTests
//
//  Created by Łukasz Kasperek on 03/01/2021.
//  Copyright © 2021 Łukasz Kasperek. All rights reserved.
//

import Foundation
import UIKit
@testable import Core
import XCTest

class UINotificationFeedbackGeneratorMock: UINotificationFeedbackGenerator {
    override init() {
        super.init()
        UINotificationFeedbackGeneratorInjector.instances.append(WeakBox(self))
    }
    
    private(set) var receivedNotifications = [UINotificationFeedbackGenerator.FeedbackType]()
    override func notificationOccurred(_ notificationType: UINotificationFeedbackGenerator.FeedbackType) {
        receivedNotifications.append(notificationType)
    }
    
    func verify_givenFeedback(_ feedback: UINotificationFeedbackGenerator.FeedbackType...) {
        XCTAssertEqual(receivedNotifications, feedback)
    }
}

class UINotificationFeedbackGeneratorInjector: MetaTypeInjector<UINotificationFeedbackGenerator, UINotificationFeedbackGeneratorMock> {
    fileprivate static var instances = [WeakBox<UINotificationFeedbackGeneratorMock>]()
    
    init() {
        super.init(mockClass: UINotificationFeedbackGeneratorMock.self)
    }
    
    override var injected: [WeakBox<UINotificationFeedbackGeneratorMock>] {
        get { Self.instances }
        set { Self.instances = newValue }
    }
    
    override var metatype: UINotificationFeedbackGenerator.Type {
        get { metaUINotificationFeedbackGenerator }
        set { metaUINotificationFeedbackGenerator = newValue }
    }
}
