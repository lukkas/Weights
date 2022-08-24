//
//  Plan+ModelAdapting.swift
//  Weights
//
//  Created by Łukasz Kasperek on 15/08/2022.
//

import Core
import Foundation
import Services

extension Services.Plan {
    func toCore() -> Core.Plan {
        return Core.Plan(
            name: name,
            days: days.map({ ($0 as! Services.PlannedDay).toCore() })
        )
    }
}

extension Services.PlannedDay {
    func toCore() -> Core.PlannedDay {
        return Core.PlannedDay(
            name: name,
            exercises: exercises.map({ ($0 as! Services.PlannedExercise).toCore() })
        )
    }
}

extension Services.PlannedExercise {
    func toCore() -> Core.PlannedExercise {
        return Core.PlannedExercise(
            exercise: exercise.toCore(),
            setCollections: setCollections.map({ $0.toCore() }),
            createsSupersets: createsSupersets
        )
    }
}
