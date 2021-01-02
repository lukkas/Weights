//
//  MetatypeInjector.swift
//  CoreTests
//
//  Created by Łukasz Kasperek on 02/01/2021.
//  Copyright © 2021 Łukasz Kasperek. All rights reserved.
//

import Foundation
import XCTest

struct WeakBox<T: AnyObject> {
    fileprivate weak var object: T?
    
    init(_ object: T) {
        self.object = object
    }
}

class MetaTypeInjector<Base, Mock: AnyObject> {
    private let mockClass: Base.Type
    private var originalType: Base.Type!
    
    init(mockClass: Base.Type) {
        self.mockClass = mockClass
        originalType = metatype
        metatype = mockClass.self
    }
    
    deinit {
        injected = []
        metatype = originalType
    }
    
    var metatype: Base.Type {
        get { abstractProperty() }
        set { abstractProperty() }
    }
    
    var injected: [WeakBox<Mock>] {
        get { abstractProperty() }
        set { abstractProperty() }
    }
    
    private func abstractProperty() -> Never {
        fatalError(
            """
            Abstract class
            This property needs to be overriden
            """
        )
    }
    
    var createdInstances: [Mock?] {
        return injected.map(\.object)
    }
    
    var aliveInstances: [Mock] {
        return injected.compactMap(\.object)
    }
    
    func verify_noAliveInstances() {
        XCTAssertEqual(aliveInstances.count, 0)
    }
    
    func verify_oneInstanceAlive() {
        XCTAssertEqual(aliveInstances.count, 1)
    }
    
    func verify_numberOfAliveInstances(is number: Int) {
        XCTAssertEqual(aliveInstances.count, number)
    }
    
    func getOnlyAliveInstance() throws -> Mock {
        guard aliveInstances.count == 1 else {
            throw TestFailure("Expected one alive instance of \(Self.self), got \(aliveInstances.count)")
        }
        return aliveInstances.first!
    }
    
    func getCreatedInstance(at index: Int) throws -> Mock {
        guard createdInstances.count > index else {
            throw TestFailure("Only \(createdInstances.count) were ever created")
        }
        guard let object = createdInstances[index] else {
            throw TestFailure("Created instance was already deallocated")
        }
        return object
    }
    
    func verifyInstanceWasCreatedAndDeallocated(at index: Int) {
        guard createdInstances.count > index else {
            XCTFail("Instance at index \(index) was never created")
            return
        }
        XCTAssertNil(
            createdInstances[index],
            "Object at index \(index) still exists"
        )
    }
}
