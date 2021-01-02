//
//  UIImpactFeedbackGeneratorMock.swift
//  CoreTests
//
//  Created by Łukasz Kasperek on 02/01/2021.
//  Copyright © 2021 Łukasz Kasperek. All rights reserved.
//

import Foundation
import UIKit
@testable import Core

class UIImpactFeedbackGeneratorMock: UIImpactFeedbackGenerator {
    override init() {
        super.init()
        UIImpactFeedbackGeneratorInjector.instances.append(WeakBox(self))
    }
}

class UIImpactFeedbackGeneratorInjector: MetaTypeInjector<UIImpactFeedbackGenerator, UIImpactFeedbackGeneratorMock> {
    fileprivate static var instances = [WeakBox<UIImpactFeedbackGeneratorMock>]()
    
    init() {
        super.init(mockClass: UIImpactFeedbackGeneratorMock.self)
    }
    
    override var injected: [WeakBox<UIImpactFeedbackGeneratorMock>] {
        get { Self.instances }
        set { Self.instances = newValue }
    }
    
    override var metatype: UIImpactFeedbackGenerator.Type {
        get { metaUIImpactFeedbackGenerator }
        set { metaUIImpactFeedbackGenerator = newValue }
    }
}
