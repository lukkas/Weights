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
    @Published var variations: [PlannerSetCellModel] = [] {
        didSet {
            performPostVariationsModificationCheck()
        }
    }
    
    private let exercise: Exercise
    
    init(exercise: Exercise) {
        self.exercise = exercise
        prepareInitialVariationsState()
    }
    
    private func prepareInitialVariationsState() {
        variations = [baseVariation()]
    }
    
    private func baseVariation() -> PlannerSetCellModel {
        PlannerSetCellModel(
            metric: exercise.metric,
            numerOfSets: 1,
            metricValue: 0,
            weight: 0
        )
    }
    
    private func performPostVariationsModificationCheck() {
        if let index = variations.lastIndex(where: { $0.numberOfSets == 0 }) {
            variations.remove(at: index)
        }
    }
    
    func addVariationTapped() {
        variations.append(baseVariation())
    }
}
