//
//  PlannerInteractor.swift
//  Core
//
//  Created by Łukasz Kasperek on 26/10/2022.
//

import Foundation

protocol PlannerInteracting {
    
}

class PlannerInteractor: PlannerInteracting {
    private let planStorage: PlanStoring
    
    init(planStorage: PlanStoring) {
        self.planStorage = planStorage
    }
}
