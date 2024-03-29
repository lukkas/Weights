//
//  UITapGestureRecognizerMock.swift
//  CoreTests
//
//  Created by Łukasz Kasperek on 02/01/2021.
//  Copyright © 2021 Łukasz Kasperek. All rights reserved.
//

import Foundation
import UIKit
@testable import Core

class UITapGestureRecognizerMock: UITapGestureRecognizer {
    override init(target: Any?, action: Selector?) {
        self.target = target
        self.selector = action
        super.init(target: target, action: action)
        UITapGestureRecognizerMockInjector.instances.append(WeakBox(self))
    }
    
    private var target: Any?
    private var selector: Selector?
    override func addTarget(_ target: Any, action: Selector) {
        self.target = target
        self.selector = action
    }
    
    private func callSelector() {
        _ = (target as AnyObject).perform(selector, with: self)
    }
    
    func tap() {
        callSelector()
    }
}

class UITapGestureRecognizerMockInjector: MetaTypeInjector<UITapGestureRecognizer, UITapGestureRecognizerMock> {
    fileprivate static var instances: [WeakBox<UITapGestureRecognizerMock>] = []
    
    init() {
        super.init(mockClass: UITapGestureRecognizerMock.self)
    }
    
    override var injected: [WeakBox<UITapGestureRecognizerMock>] {
        get { Self.instances }
        set { Self.instances = newValue }
    }
    
    override var metatype: UITapGestureRecognizer.Type {
        get { metaUITapGestureRecognizer }
        set { metaUITapGestureRecognizer = newValue }
    }
}


