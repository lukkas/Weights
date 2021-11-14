//
//  PlannerViewModel.swift
//  Core
//
//  Created by Łukasz Kasperek on 04/10/2020.
//  Copyright © 2020 Łukasz Kasperek. All rights reserved.
//

import Foundation
import Combine

class PlannerViewModel: PlannerViewModeling {
    typealias ExerciseViewModelType = PlannerExerciseViewModel
    
    @Published var trainingUnits: [TrainingUnitModel<PlannerExerciseViewModel>] = []
    @Published var visibleUnit: Int = 0
    var currentUnitName: String {
        get {
            trainingUnits[visibleUnit].name
        }
        set {
            trainingUnits[visibleUnit].name = newValue
        }
    }
    
    init() {
        trainingUnits = [makeTemplateUnitModel()]
    }
    
    private func makeTemplateUnitModel() -> TrainingUnitModel<PlannerExerciseViewModel> {
        return TrainingUnitModel(
            name: "A1",
            exercises: []
        )
    }
    
    func addExerciseTapped() {
        
    }
    
    func leftArrowTapped() {
        
    }
    
    func rightArrowTapped() {
        
    }
    
    func plusTapped() {
        
    }
}
