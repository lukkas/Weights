//
//  PlannerExerciseViewModel.swift
//  Core
//
//  Created by Łukasz Kasperek on 07/11/2021.
//  Copyright © 2021 Łukasz Kasperek. All rights reserved.
//

import Foundation

class PlannerExerciseViewModel: ObservableObject, Identifiable, Hashable {
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
    
    static func == (lhs: PlannerExerciseViewModel, rhs: PlannerExerciseViewModel) -> Bool {
        return
            lhs.id == rhs.id
            && lhs.exerciseId == rhs.exerciseId
            && lhs.name == rhs.name
            && lhs.variations == rhs.variations
            && lhs.pace == rhs.pace
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(exerciseId)
        hasher.combine(name)
        hasher.combine(variations)
        hasher.combine(pace)
    }
}
