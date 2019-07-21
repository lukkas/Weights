//
//  ExerciseCellModel.swift
//  Weights
//
//  Created by Łukasz Kasperek on 14/07/2019.
//  Copyright © 2019 Łukasz Kasperek. All rights reserved.
//

import Foundation
import SwiftUI

struct ExerciseCellModel: Identifiable {
    let id = UUID()
    
    let name: String
    let muscleGroup: String
    let nextPerformance: String
}

#if DEBUG
extension ExerciseCellModel {
    static var sample: ExerciseCellModel {
        ExerciseCellModel(
            name: "Squat",
            muscleGroup: "Legs",
            nextPerformance: "Tomorrow"
        )
    }
}
#endif
