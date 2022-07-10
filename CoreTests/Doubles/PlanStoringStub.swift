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
    var currentPlan: AnyPublisher<Plan?, Never> {
        return Just(nil).eraseToAnyPublisher()
    }
    var autoupdatingPlans: AnyPublisher<[Plan], Never> {
        return Just([]).eraseToAnyPublisher()
    }
    func insert(_ plan: Plan) {
        
    }
}
