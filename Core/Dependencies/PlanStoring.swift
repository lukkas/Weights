//
//  PlanStoring.swift
//  Core
//
//  Created by Łukasz Kasperek on 16/06/2022.
//

import Combine
import Foundation

protocol PlanStoring {
    var currentPlan: AnyPublisher<Plan?, Never> { get }
    var autoupdatingPlans: AnyPublisher<[Plan], Never> { get }
    func insert(_ plan: Plan)
}
