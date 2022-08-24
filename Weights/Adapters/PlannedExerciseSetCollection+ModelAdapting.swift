//
//  PlannedExerciseSetCollection+ModelAdapting.swift
//  Weights
//
//  Created by Łukasz Kasperek on 24/08/2022.
//

import Core
import Foundation
import Services

extension Services.PlannedExercise.SetCollection {
    func toCore() -> Core.PlannedExercise.SetCollection {
        return .init(
            numberOfSets: numberOfSets,
            volume: volume,
            weight: weight.toCore()
        )
    }
}

extension Core.PlannedExercise.SetCollection {
    func toServices() -> Services.PlannedExercise.SetCollection {
        return .init(
            numberOfSets: numberOfSets,
            volume: volume,
            weight: weight.toServices()
        )
    }
}


