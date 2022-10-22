//
//  PlannerExerciseSupersetViewModel.swift
//  Core
//
//  Created by Łukasz Kasperek on 08/10/2022.
//

import Foundation

class PlannerExerciseViewModel: ObservableObject, Identifiable {
    enum SupersetAction {
        case add, remove
    }
    
    @Published var headerRows: [PlannerExerciseHeaderRow]
    @Published var variations: [PlannerSetsCellModel] {
        didSet {
            onVariationsChanged(variations)
        }
    }
    @Published var supersetAddEnabled: Bool = true
    @Published var supersetRemoveEnabled: Bool = true
    
    private let onAddVarationTap: () -> Void
    private let onSupersetAction: (SupersetAction) -> Void
    private let onVariationsChanged: ([PlannerSetsCellModel]) -> Void
    
    init(
        headerRows: [PlannerExerciseHeaderRow],
        variations: [PlannerSetsCellModel],
        onAddVarationTap: @escaping () -> Void,
        onSupersetAction: @escaping (SupersetAction) -> Void,
        onVariationsChanged: @escaping ([PlannerSetsCellModel]) -> Void
    ) {
        self.headerRows = headerRows
        self.variations = variations
        self.onAddVarationTap = onAddVarationTap
        self.onSupersetAction = onSupersetAction
        self.onVariationsChanged = onVariationsChanged
    }
    
    func addVariationTapped() {
        onAddVarationTap()
    }
    
    func addToSuperset() {
        onSupersetAction(.add)
    }
    
    func removeFromSuperset() {
        onSupersetAction(.remove)
    }
}

extension PlannerExerciseViewModel: Hashable {
    static func == (lhs: PlannerExerciseViewModel, rhs: PlannerExerciseViewModel) -> Bool {
        return
            lhs.id == rhs.id
            && lhs.headerRows == rhs.headerRows
            && lhs.variations == rhs.variations
            && lhs.supersetAddEnabled == rhs.supersetAddEnabled
            && lhs.supersetRemoveEnabled == rhs.supersetRemoveEnabled
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(headerRows)
        hasher.combine(variations)
        hasher.combine(supersetAddEnabled)
        hasher.combine(supersetRemoveEnabled)
    }
}
