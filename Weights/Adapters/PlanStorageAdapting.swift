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
            let insertedPlan = context.insertObject() as Services.Plan
            insertedPlan.name = plan.name
        }
    }
    
    public var currentPlan: AnyPublisher<Core.Plan?, Never> {
        return Just(nil).eraseToAnyPublisher()
    }
    
    public var autoupdatingPlans: AnyPublisher<[Core.Plan], Never> {
        let originalPublisher = autoupdatingPlans() as AnyPublisher<[Services.Plan], _>
        return originalPublisher
            .map { databasePlans in
                databasePlans.map({ $0.toCore() })
            }
            .eraseToAnyPublisher()
    }
}
