//
//  PlannerDropController.swift
//  Core
//
//  Created by Łukasz Kasperek on 27/03/2022.
//

import Foundation
import SwiftUI

class PlannerDropController<ExerciseViewModel: PlannerExerciseViewModeling>: DropDelegate {
    private let exercise: ExerciseViewModel
    
    init(exercise: ExerciseViewModel) {
        self.exercise = exercise
    }
    
    func performDrop(info: DropInfo) -> Bool {
        return true
    }
    
    func dropEntered(info: DropInfo) {
        
    }
    
    func dropUpdated(info: DropInfo) -> DropProposal? {
        return DropProposal(operation: .move)
    }
}
