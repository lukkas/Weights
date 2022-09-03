//
//  PlanViewModel.swift
//  Core
//
//  Created by Łukasz Kasperek on 24/08/2022.
//

import Combine
import Foundation

class PlanViewModel: PlanViewModeling {
    @Published private(set) var currentPlan: ActivePlanCellModel?
    @Published private(set) var otherPlans: [PlanCellModel] = []
    
    private let planStorage: PlanStoring
    private var cancellables: Set<AnyCancellable> = []
    
    init(planStorage: PlanStoring) {
        self.planStorage = planStorage
        setUpPlanStorageSubscriptions()
    }
    
    private func setUpPlanStorageSubscriptions() {
        planStorage.autoupdatingPlans
            .sink { [weak self] plans in
                self?.populatePlanViewModels(with: plans)
            }
            .store(in: &cancellables)
    }
    
    private func populatePlanViewModels(with plans: [Plan]) {
        var otherPlans = [PlanCellModel]()
        for plan in plans {
            if plan.isCurrent {
                currentPlan = createActivePlanCellViewModel(from: plan)
            } else {
                otherPlans.append(createPlanCellModel(from: plan))
            }
        }
        self.otherPlans = otherPlans
    }
    
    private func createActivePlanCellViewModel(
        from plan: Plan
    ) -> ActivePlanCellModel {
        return ActivePlanCellModel(
            name: plan.name,
            days: [],
            selectedDayDescription: [],
            schedulingInfo: AttributedString()
        )
    }
    
    private func createPlanCellModel(from plan: Plan) -> PlanCellModel {
        return PlanCellModel(
            id: plan.id,
            name: plan.name,
            days: []
        )
    }
}
