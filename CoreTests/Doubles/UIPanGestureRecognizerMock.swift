//
//  UIPanGestureRecognizerMock.swift
//  CoreTests
//
//  Created by Łukasz Kasperek on 02/01/2021.
//  Copyright © 2021 Łukasz Kasperek. All rights reserved.
//

import Foundation
import UIKit
@testable import Core

class UIPanGestureRecognizerMock: UIPanGestureRecognizer {
    override init(target: Any?, action: Selector?) {
        self.target = target
        self.selector = action
        super.init(target: target, action: action)
        UIPanGestureRecognizerMockInjector.instances.append(WeakBox(self))
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
    
    private var underlyingTranslation: CGPoint?
    override func translation(in view: UIView?) -> CGPoint {
        if let translation = underlyingTranslation {
            return translation
        }
        return super.translation(in: view)
    }
    
    func beginPanning() {
        state = .began
        callSelector()
    }
    
    func continuePanning(by translation: CGPoint) {
        underlyingTranslation = translation
        state = .changed
        callSelector()
    }
    
    func endPanning() {
        state = .ended
        callSelector()
    }
    
    func cancelPanning() {
        state = .cancelled
        callSelector()
    }
}

class UIPanGestureRecognizerMockInjector: MetaTypeInjector<UIPanGestureRecognizer, UIPanGestureRecognizerMock> {
    fileprivate static var instances: [WeakBox<UIPanGestureRecognizerMock>] = []
    
    init() {
        super.init(mockClass: UIPanGestureRecognizerMock.self)
    }
    
    override var injected: [WeakBox<UIPanGestureRecognizerMock>] {
        get { Self.instances }
        set { Self.instances = newValue }
    }
    
    override var metatype: UIPanGestureRecognizer.Type {
        get { metaUIPanGestureRecognizer }
        set { metaUIPanGestureRecognizer = newValue }
    }
}
