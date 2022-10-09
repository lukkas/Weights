//
//  PlannerExerciseSupersetViewModel.swift
//  Core
//
//  Created by Łukasz Kasperek on 08/10/2022.
//

import Foundation

class PlannerExerciseViewModel: ObservableObject, Identifiable {
    @Published var headerRows: [PlannerExerciseHeaderRow]
    @Published var variations: [PlannerSetsCellModel] {
        didSet {
            onVariationsChanged(variations)
        }
    }
    
    private let onAddVarationTap: () -> Void
    private let onVariationsChanged: ([PlannerSetsCellModel]) -> Void
    
    init(
        headerRows: [PlannerExerciseHeaderRow],
        variations: [PlannerSetsCellModel],
        onAddVarationTap: @escaping () -> Void,
        onVariationsChanged: @escaping ([PlannerSetsCellModel]) -> Void
    ) {
        self.headerRows = headerRows
        self.variations = variations
        self.onAddVarationTap = onAddVarationTap
        self.onVariationsChanged = onVariationsChanged
    }
    
    func addVariationTapped() {
        onAddVarationTap()
    }
}

extension PlannerExerciseViewModel: Hashable {
    static func == (lhs: PlannerExerciseViewModel, rhs: PlannerExerciseViewModel) -> Bool {
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
