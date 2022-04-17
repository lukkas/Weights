//
//  PlannerExerciseDraggable.swift
//  Core
//
//  Created by Łukasz Kasperek on 27/03/2022.
//

import Foundation
import UniformTypeIdentifiers

enum PlannerExerciseDraggable {
    static let name = "plannerExercise"
    static let uti = UTType("com.lukaszkasperek.weights.plannerExercise")!
    static let itemProvider = NSItemProvider(
        item: PlannerExerciseDraggable.name as NSString,
        typeIdentifier: PlannerExerciseDraggable.uti.identifier
    )
}
