//
//  PlannerDropController.swift
//  Core
//
//  Created by Łukasz Kasperek on 27/03/2022.
//

import Foundation
import SwiftUI

enum PlannerDraggingTarget<ExerciseViewModel: PlannerExerciseViewModeling> {
    case emptyPage(PlannerPageViewModel<ExerciseViewModel>)
    case exercise(ExerciseViewModel)
}

protocol PlannerDropControllerDelegate: AnyObject {
    associatedtype ExerciseViewModel: PlannerExerciseViewModeling
    
    func currentlyDraggedItem(wasDraggedOver target: PlannerDraggingTarget<ExerciseViewModel>)
}

class PlannerDropController<
    ExerciseViewModel, Delegate: PlannerDropControllerDelegate
>: DropDelegate where ExerciseViewModel == Delegate.ExerciseViewModel {
    private let target: PlannerDraggingTarget<ExerciseViewModel>
    @Binding private var currentlyDragged: ExerciseViewModel?
    @Binding private var pages: [PlannerPageViewModel<ExerciseViewModel>]
    private unowned let delegate: Delegate
    
    init(
        target: PlannerDraggingTarget<ExerciseViewModel>,
        currentlyDragged: Binding<ExerciseViewModel?>,
        pages: Binding<[PlannerPageViewModel<ExerciseViewModel>]>,
        delegate: Delegate
    ) {
        self.target = target
        self._currentlyDragged = currentlyDragged
        self._pages = pages
        self.delegate = delegate
    }
    
    func performDrop(info: DropInfo) -> Bool {
        return true
    }
    
    func dropEntered(info: DropInfo) {
        withAnimation {
            currentlyDraggedItem()
        }
    }
    
    func dropUpdated(info: DropInfo) -> DropProposal? {
        return DropProposal(operation: .move)
    }
    
    private func currentlyDraggedItem() {
        guard let currentlyDraggedItem = currentlyDragged else {
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
            pages[draggedItemIP.section].removeExercise(at: draggedItemIP.item)
        }
    }
    
    private func indexPathOfTrainingUnit(
        containing item: ExerciseViewModel
    ) -> IndexPath? {
        for (unitIndex, unit) in pages.enumerated() {
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
            let unit = pages[sourceIndexPath.section]
            let to = targetIndexPath.item > sourceIndexPath.item
            ? targetIndexPath.item + 1
            : targetIndexPath.item
            unit.move(fromOffsets: IndexSet(integer: sourceIndexPath.item), to: to)
        } else {
            let sourceUnit = pages[sourceIndexPath.section]
            let targetUnit = pages[targetIndexPath.section]
            let sourceExercise = sourceUnit.exercises[sourceIndexPath.item]
            sourceUnit.removeExercise(at: sourceIndexPath.item)
            targetUnit.insertExercise(sourceExercise, at: targetIndexPath.item)
        }
    }
}
