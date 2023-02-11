//
//  PlannedExerciseSetCollection+ModelAdapting.swift
//  Weights
//
//  Created by Łukasz Kasperek on 24/08/2022.
//

import Core
import Foundation
import Services

extension Services.PlannedExercise.Set {
    func toCore() -> Core.PlannedExercise.Set {
        return .init(volume: volume, weight: weight.toCore())
    }
}

extension Core.PlannedExercise.Set {
    func toServices() -> Services.PlannedExercise.Set {
        return .init(volume: volume, weight: weight.toServices())
    }
}


