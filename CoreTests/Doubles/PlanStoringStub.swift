//
//  PlanStoringStub.swift
//  CoreTests
//
//  Created by Łukasz Kasperek on 10/07/2022.
//

import Combine
@testable import Core
import Foundation

class PlanStoringStub: PlanStoring {
    private let plans = CurrentValueSubject<[Plan], Never>([])
    
    // MARK: - Interface
    
    var autoupdatingPlans: AnyPublisher<[Plan], Never> {
        return plans.eraseToAnyPublisher()
    }
    
    func insert(_ plan: Plan) {
        
    }
    
    // MARK: - Stubbing
    
    func setPlans(_ plans: [Plan]) {
        self.plans.send(plans)
    }
    
    func append(_ plan: Plan) {
        self.plans.value.append(plan)
    }
}
