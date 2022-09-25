//
//  PlannerExerciseViewModel.swift
//  Core
//
//  Created by Łukasz Kasperek on 07/11/2021.
//  Copyright © 2021 Łukasz Kasperek. All rights reserved.
//

import Foundation

class PlannerExerciseViewModel: PlannerExerciseViewModeling {
    let exerciseId: UUID
    let name: String
    @Published var pace = UIPacePicker.InputState()
    @Published var variations: [PlannerSetCellModel] {
        didSet {
            onVariationsChanged(variations)
        }
    }
    
    private let onAddVarationTap: () -> Void
    private let onVariationsChanged: ([PlannerSetCellModel]) -> Void
    
    init(
        exerciseId: UUID,
        exerciseName: String,
        setVariations: [PlannerSetCellModel],
        onAddVarationTap: @escaping () -> Void,
        onVariationsChanged: @escaping ([PlannerSetCellModel]) -> Void
    ) {
        self.exerciseId = exerciseId
        self.name = exerciseName
        self.variations = setVariations
        self.onAddVarationTap = onAddVarationTap
        self.onVariationsChanged = onVariationsChanged
    }
    
    func addVariationTapped() {
        onAddVarationTap()
    }
}
