//
//  PlannerDropController.swift
//  Core
//
//  Created by Łukasz Kasperek on 27/03/2022.
//

import Foundation
import SwiftUI

enum PlannerDraggingTarget {
    case emptyPage(PlannerPage)
    case exercise(PlannerExercise)
}

protocol PlannerDropControllerDelegate: AnyObject {
    func currentlyDraggedItem(wasDraggedOver target: PlannerDraggingTarget)
}

class PlannerDropController: DropDelegate {
    private let target: PlannerDraggingTarget
    @Binding private var currentlyDragged: PlannerExercise?
    @Binding private var pages: [PlannerPage]
    
    init(
        target: PlannerDraggingTarget,
        currentlyDragged: Binding<PlannerExercise?>,
        pages: Binding<[PlannerPage]>
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
            guard let emptyPageIndex = pages.firstIndex(of: page) else { return }
            pages[emptyPageIndex].exercises.append(currentlyDragged)
            pages[draggedItemIP.section].exercises.remove(at: draggedItemIP.item)
        }
    }
    
    private func indexPath(of item: PlannerExercise) -> IndexPath? {
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
            let to = targetIndexPath.item > sourceIndexPath.item
            ? targetIndexPath.item + 1
            : targetIndexPath.item
            pages[sourceIndexPath.section].exercises.move(
                fromOffsets: IndexSet(integer: sourceIndexPath.item),
                toOffset: to
            )
        } else {
            let sourceExercise = pages[sourceIndexPath.section].exercises[sourceIndexPath.item]
            pages[sourceIndexPath.section].exercises.remove(at: sourceIndexPath.item)
            pages[targetIndexPath.section].exercises.insert(sourceExercise, at: targetIndexPath.item)
        }
    }
}
