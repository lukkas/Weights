//
//  PlanViewModel.swift
//  Core
//
//  Created by Łukasz Kasperek on 24/08/2022.
//

import Foundation

class PlanViewModel: PlanViewModeling {
    private let planStorage: PlanStoring
    
    init(planStorage: PlanStoring) {
        self.planStorage = planStorage
    }
}
