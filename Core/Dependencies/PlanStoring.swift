//
//  PlanStoring.swift
//  Core
//
//  Created by Łukasz Kasperek on 16/06/2022.
//

import Combine
import Foundation

public protocol PlanStoring {
    var autoupdatingPlans: AnyPublisher<[Plan], Never> { get }
    func insert(_ plan: Plan)
}

#if DEBUG

public class DTPlanStorage: PlanStoring {
    public init() {}
    
    public var autoupdatingPlans: AnyPublisher<[Plan], Never> {
        Just([]).eraseToAnyPublisher()
    }
    
    public func insert(_ plan: Plan) {
        
    }
}

#endif
