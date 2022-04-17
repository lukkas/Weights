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
        let unit = trainingUnits[visibleUnit]
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
    
    func currentlyDraggedItem(wasDraggedOver target: PlannerDraggingTarget<PlannerExerciseViewModel>) {
        guard let currentlyDraggedItem = currentlyDraggedItem else {
            return
        }
        guard let draggedItemIP = indexPathOfTrainingUnit(containing: currentlyDraggedItem) else {
            return
        }
        switch target {
        case let .exercise(item):
            guard let draggedOverItemIP = indexPathOfTrainingUnit(containing: item) else {
                return
            }
            guard draggedItemIP != draggedOverItemIP else {
                return
            }
            swapItems(sourceIndexPath: draggedItemIP, targetIndexPath: draggedOverItemIP)
        case let .emptyPage(page):
            page.addExercises([currentlyDraggedItem])
            trainingUnits[draggedItemIP.section].removeExercise(at: draggedItemIP.item)
        }
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
        if sourceIndexPath.section == targetIndexPath.section {
            let unit = trainingUnits[sourceIndexPath.section]
            let to = targetIndexPath.item > sourceIndexPath.item
            ? targetIndexPath.item + 1
            : targetIndexPath.item
            unit.move(fromOffsets: IndexSet(integer: sourceIndexPath.item), to: to)
        } else {
            let sourceUnit = trainingUnits[sourceIndexPath.section]
            let targetUnit = trainingUnits[targetIndexPath.section]
            let sourceExercise = sourceUnit.exercises[sourceIndexPath.item]
            sourceUnit.removeExercise(at: sourceIndexPath.item)
            targetUnit.insertExercise(sourceExercise, at: targetIndexPath.item)
        }
    }
}
