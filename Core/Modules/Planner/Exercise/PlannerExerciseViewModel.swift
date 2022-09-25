//
//  PlannerExerciseViewModel.swift
//  Core
//
//  Created by Łukasz Kasperek on 07/11/2021.
//  Copyright © 2021 Łukasz Kasperek. All rights reserved.
//

import Foundation

class PlannerExerciseViewModel: PlannerExerciseViewModeling {
    var name: String { exercise.name }
    @Published var pace = UIPacePicker.InputState()
    @Published var variations: [PlannerSetCellModel] {
        didSet {
            onVariationsChanged(variations)
        }
    }
    
    let exercise: Exercise
    private let onAddVarationTap: () -> Void
    private let onVariationsChanged: ([PlannerSetCellModel]) -> Void
    
    init(
        exercise: Exercise,
        setVariations: [PlannerSetCellModel],
        onAddVarationTap: @escaping () -> Void,
        onVariationsChanged: @escaping ([PlannerSetCellModel]) -> Void
    ) {
        self.exercise = exercise
        self.variations = setVariations
        self.onAddVarationTap = onAddVarationTap
        self.onVariationsChanged = onVariationsChanged
    }
    
    func addVariationTapped() {
        onAddVarationTap()
    }
}
