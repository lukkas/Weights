//
//  PlannerViewModel.swift
//  Core
//
//  Created by Łukasz Kasperek on 04/10/2020.
//  Copyright © 2020 Łukasz Kasperek. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

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
    typealias ExerciseViewModel = PlannerExerciseViewModel
    
    @Published var trainingUnits: [TrainingUnitModel<PlannerExerciseViewModel>] = []
    @Published var visibleUnit: Int = 0
    var leftArrowDisabled: Bool {
        return visibleUnit == 0
    }
    var rightArrowDisabled: Bool {
        return visibleUnit == trainingUnits.indices.last
    }
    var currentUnitName: String {
        get {
            trainingUnits[visibleUnit].name
        }
        set {
            trainingUnits[visibleUnit].name = newValue
        }
    }
    @Published var exercisePickerRelay: ExercisePickerRelay?
    private var currentlyDraggedItem: PlannerExerciseViewModel?
    
    init() {
        trainingUnits = [makeTemplateUnitModel()]
    }
    
    private func makeTemplateUnitModel() -> TrainingUnitModel<PlannerExerciseViewModel> {
        return TrainingUnitModel(name: "A1")
    }
    
    func addExerciseTapped() {
        exercisePickerRelay = ExercisePickerRelay(onPicked: { [weak self] exercises in
            self?.handleExercisesPicked(exercises)
            self?.exercisePickerRelay = nil
        })
    }
    
    private func handleExercisesPicked(_ exercises: [Exercise])  {
        var unit = trainingUnits[visibleUnit]
        defer { trainingUnits[visibleUnit] = unit }
        let exerciseModels = exercises.map {
            PlannerExerciseViewModel(exercise: $0)
        }
        unit.addExercises(exerciseModels)
    }
    
    func leftArrowTapped() {
        if leftArrowDisabled { return }
        visibleUnit -= 1
    }
    
    func rightArrowTapped() {
        if rightArrowDisabled { return }
        visibleUnit += 1
    }
    
    func plusTapped() {
        trainingUnits.append(makeTemplateUnitModel())
        visibleUnit = trainingUnits.indices.last!
    }
    
    func startDragging(of item: PlannerExerciseViewModel) {
        currentlyDraggedItem = item
    }
    
    func currentlyDraggedItem(wasDraggedOver item: PlannerExerciseViewModel) {
        guard let currentlyDraggedItem = currentlyDraggedItem else {
            return
        }
        guard let draggedItemIP = indexPathOfTrainingUnit(containing: currentlyDraggedItem) else {
            return
        }
        guard let draggedOverItemIP = indexPathOfTrainingUnit(containing: item) else {
            return
        }
        guard draggedItemIP != draggedOverItemIP else {
            return
        }
        swapItems(sourceIndexPath: draggedItemIP, targetIndexPath: draggedOverItemIP)
    }
    
    private func indexPathOfTrainingUnit(
        containing item: PlannerExerciseViewModel
    ) -> IndexPath? {
        for (unitIndex, unit) in trainingUnits.enumerated() {
            for (exerciseIndex, exercise) in unit.exercises.enumerated() where exercise == item {
                return IndexPath(item: exerciseIndex, section: unitIndex)
            }
        }
        return nil
    }
    
    private func swapItems(
        sourceIndexPath: IndexPath,
        targetIndexPath: IndexPath
    ) {
        var unitsCopy = trainingUnits
        if sourceIndexPath.section == targetIndexPath.section {
            var unit = unitsCopy[sourceIndexPath.section]
            let sourceExercise = unit.exercises[sourceIndexPath.item]
            let targetExercise = unit.exercises[targetIndexPath.item]
            unit.replaceExercise(at: sourceIndexPath.item, with: targetExercise)
            unit.replaceExercise(at: targetIndexPath.item, with: sourceExercise)
            unitsCopy[sourceIndexPath.section] = unit
            trainingUnits = unitsCopy
        } else {
            var sourceUnit = unitsCopy[sourceIndexPath.section]
            var targetUnit = unitsCopy[targetIndexPath.section]
            let sourceExercise = sourceUnit.exercises[sourceIndexPath.item]
            let targetExercise = targetUnit.exercises[targetIndexPath.item]
            sourceUnit.replaceExercise(at: sourceIndexPath.item, with: targetExercise)
            targetUnit.replaceExercise(at: targetIndexPath.item, with: sourceExercise)
            unitsCopy[sourceIndexPath.section] = sourceUnit
            unitsCopy[targetIndexPath.section] = targetUnit
            trainingUnits = unitsCopy
        }
    }
}
