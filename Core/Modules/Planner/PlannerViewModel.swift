//
//  PlannerViewModel.swift
//  Core
//
//  Created by Łukasz Kasperek on 04/10/2020.
//  Copyright © 2020 Łukasz Kasperek. All rights reserved.
//

import Foundation
import Combine

struct ExercisePickerRelay: Identifiable {
    let id = UUID()
    private let onPicked: ([Exercise]) -> Void
    
    init(onPicked: @escaping ([Exercise]) -> Void) {
        self.onPicked = onPicked
    }
    
    func pick(_ exercises: [Exercise]) {
        onPicked(exercises)
    }
}

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
    @Published var exercisePickerRelay: ExercisePickerRelay?
    
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
        exercisePickerRelay = ExercisePickerRelay(onPicked: { [weak self] exercises in
            self?.handleExercisesPicked(exercises)
            self?.exercisePickerRelay = nil
        })
    }
    
    private func handleExercisesPicked(_ exercises: [Exercise])  {
        var unit = trainingUnits[visibleUnit]
        let exerciseModels = exercises.map {
            PlannerExerciseViewModel(exercise: $0)
        }
        unit.addExercises(exerciseModels)
        trainingUnits[visibleUnit] = unit
    }
    
    func leftArrowTapped() {
        
    }
    
    func rightArrowTapped() {
        
    }
    
    func plusTapped() {
        trainingUnits.append(makeTemplateUnitModel())
    }
}
