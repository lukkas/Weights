//
//  UISelectionFeedbackGenerator.swift
//  CoreTests
//
//  Created by Łukasz Kasperek on 02/01/2021.
//  Copyright © 2021 Łukasz Kasperek. All rights reserved.
//

@testable import Core
import Foundation
import UIKit

class UISelectionFeedbackGeneratorMock: UISelectionFeedbackGenerator {
    override init() {
        super.init()
        UISelectionFeedbackGeneratorInjector.instances.append(WeakBox(self))
    }
}

class UISelectionFeedbackGeneratorInjector: MetaTypeInjector<UISelectionFeedbackGenerator, UISelectionFeedbackGeneratorMock> {
    fileprivate static var instances = [WeakBox<UISelectionFeedbackGeneratorMock>]()
    
    init() {
        super.init(mockClass: UISelectionFeedbackGeneratorMock.self)
    }
    
    override var injected: [WeakBox<UISelectionFeedbackGeneratorMock>] {
        get { Self.instances }
        set { Self.instances = newValue }
    }
    
    override var metatype: UISelectionFeedbackGenerator.Type {
        get { metaUISelectionFeedbackGenerator }
        set { metaUISelectionFeedbackGenerator = newValue }
    }
}
