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

class PanGestureRecognizerMock: UIPanGestureRecognizer {
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
    
    func startPanning() {
//        setTranslation(<#T##translation: CGPoint##CGPoint#>, in: <#T##UIView?#>)
        state = .began
    }
    
    func pan() {
        
    }
    
    func endPanning() {
        
    }
    
    func cancelPanning() {
        
    }
}

class UIPanGestureRecognizerMockInjector: MetaTypeInjector<UIPanGestureRecognizer, PanGestureRecognizerMock> {
    fileprivate static var instances: [WeakBox<PanGestureRecognizerMock>] = []
    
    init() {
        super.init(mockClass: PanGestureRecognizerMock.self)
    }
    
    override var injected: [WeakBox<PanGestureRecognizerMock>] {
        get { Self.instances }
        set { Self.instances = newValue }
    }
    
    override var metatype: UIPanGestureRecognizer.Type {
        get { metaUIPanGestureRecognizer }
        set { metaUIPanGestureRecognizer = newValue }
    }
}
