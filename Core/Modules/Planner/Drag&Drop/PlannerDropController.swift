//
//  PlannerDropController.swift
//  Core
//
//  Created by Łukasz Kasperek on 27/03/2022.
//

import Foundation
import SwiftUI

enum PlannerDraggingTarget<ExerciseViewModel: PlannerExerciseViewModeling> {
    case emptyPage(TrainingUnitModel<ExerciseViewModel>)
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
    private unowned let delegate: Delegate
    
    init(target: PlannerDraggingTarget<ExerciseViewModel>, delegate: Delegate) {
        self.target = target
        self.delegate = delegate
    }
    
    func performDrop(info: DropInfo) -> Bool {
        return true
    }
    
    func dropEntered(info: DropInfo) {
        withAnimation {
            delegate.currentlyDraggedItem(wasDraggedOver: target)
        }
    }
    
    func dropUpdated(info: DropInfo) -> DropProposal? {
        return DropProposal(operation: .move)
    }
}
