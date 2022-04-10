//
//  PlannerDropController.swift
//  Core
//
//  Created by Łukasz Kasperek on 27/03/2022.
//

import Foundation
import SwiftUI

protocol PlannerDropControllerDelegate: AnyObject {
    associatedtype ExerciseViewModel: PlannerExerciseViewModeling
    
    func currentlyDraggedItem(wasDraggedOver item: ExerciseViewModel)
}

class PlannerDropController<
    ExerciseViewModel, Delegate: PlannerDropControllerDelegate
>: DropDelegate where ExerciseViewModel == Delegate.ExerciseViewModel {
    
    private let exercise: ExerciseViewModel
    private unowned let delegate: Delegate
    
    init(exercise: ExerciseViewModel, delegate: Delegate) {
        self.exercise = exercise
        self.delegate = delegate
    }
    
    func performDrop(info: DropInfo) -> Bool {
        return true
    }
    
    func dropEntered(info: DropInfo) {
        withAnimation {
            delegate.currentlyDraggedItem(wasDraggedOver: exercise)
        }
//        guard let draggedItem = info.itemProviders(for: [PlannerExerciseDraggable.uti]).first else {
//            return
//        }
//        draggedItem.loadObject(ofClass: PlannerExerciseViewModelArchive.self) { archive, error in
//
//        }
    }
    
    func dropUpdated(info: DropInfo) -> DropProposal? {
        return DropProposal(operation: .move)
    }
}
