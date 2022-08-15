//
//  PlanStorage.swift
//  Weights
//
//  Created by Łukasz Kasperek on 07/08/2022.
//

import Combine
import Core
import Foundation
import Services

extension PlanRepository: PlanStoring {
    public func insert(_ plan: Core.Plan) {
        insertPlan { context in
            let plan = context.insertObject() as Services.Plan
        }
    }
    
    public var currentPlan: AnyPublisher<Core.Plan?, Never> {
        return Just(nil).eraseToAnyPublisher()
    }
    
    public var autoupdatingPlans: AnyPublisher<[Core.Plan], Never> {
        return Just([]).eraseToAnyPublisher()
    }
}
