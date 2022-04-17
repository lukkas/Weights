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
    ExerciseViewModel: PlannerExerciseViewModeling
>: DropDelegate {
    private let target: PlannerDraggingTarget<ExerciseViewModel>
    @Binding private var currentlyDragged: ExerciseViewModel?
    @Binding private var pages: [PlannerPageViewModel<ExerciseViewModel>]
    
    init(
        target: PlannerDraggingTarget<ExerciseViewModel>,
        currentlyDragged: Binding<ExerciseViewModel?>,
        pages: Binding<[PlannerPageViewModel<ExerciseViewModel>]>
    ) {
        self.target = target
        self._currentlyDragged = currentlyDragged
        self._pages = pages
    }
    
    func performDrop(info: DropInfo) -> Bool {
        return true
    }
    
    func dropUpdated(info: DropInfo) -> DropProposal? {
        return DropProposal(operation: .move)
    }
    
    func dropEntered(info: DropInfo) {
        withAnimation {
            dropEntered()
        }
    }
    
    // public for testing purposes
    func dropEntered() {
        guard let currentlyDragged = currentlyDragged else { return }
        guard let draggedItemIP = indexPath(of: currentlyDragged) else { return }
        switch target {
        case let .exercise(item):
            guard let draggedOverItemIP = indexPath(of: item) else { return }
            guard draggedItemIP != draggedOverItemIP else { return }
            swapItems(sourceIndexPath: draggedItemIP, targetIndexPath: draggedOverItemIP)
        case let .emptyPage(page):
            page.addExercises([currentlyDragged])
            pages[draggedItemIP.section].removeExercise(at: draggedItemIP.item)
        }
    }
    
    private func indexPath(
        of item: ExerciseViewModel
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
            let page = pages[sourceIndexPath.section]
            let to = targetIndexPath.item > sourceIndexPath.item
            ? targetIndexPath.item + 1
            : targetIndexPath.item
            page.move(fromOffsets: IndexSet(integer: sourceIndexPath.item), to: to)
        } else {
            let sourcePage = pages[sourceIndexPath.section]
            let targetPage = pages[targetIndexPath.section]
            let sourceExercise = sourcePage.exercises[sourceIndexPath.item]
            sourcePage.removeExercise(at: sourceIndexPath.item)
            targetPage.insertExercise(sourceExercise, at: targetIndexPath.item)
        }
    }
}
