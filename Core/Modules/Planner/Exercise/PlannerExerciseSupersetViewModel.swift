//
//  PlannerExerciseSupersetViewModel.swift
//  Core
//
//  Created by Łukasz Kasperek on 08/10/2022.
//

import Foundation

class PlannerExerciseSupersetViewModel: ObservableObject, Identifiable {
    @Published var headerRows: [PlannerExerciseHeaderRow]
    @Published var variations: [PlannerSupersetCellModel]
    
    private let onAddVarationTap: () -> Void
    
    init(
        headerRows: [PlannerExerciseHeaderRow],
        variations: [PlannerSupersetCellModel],
        onAddVarationTap: @escaping () -> Void
    ) {
        self.headerRows = headerRows
        self.variations = variations
        self.onAddVarationTap = onAddVarationTap
    }
    
    func addVariationTapped() {
        onAddVarationTap()
    }
}

extension PlannerExerciseSupersetViewModel: Hashable {
    static func == (lhs: PlannerExerciseSupersetViewModel, rhs: PlannerExerciseSupersetViewModel) -> Bool {
        return
            lhs.id == rhs.id
            && lhs.headerRows == rhs.headerRows
            && lhs.variations == rhs.variations
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(headerRows)
        hasher.combine(variations)
    }
}
