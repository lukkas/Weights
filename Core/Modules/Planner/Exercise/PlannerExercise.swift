//
//  PlannerExercise.swift
//  Core
//
//  Created by Łukasz Kasperek on 12/11/2022.
//

import Foundation

struct PlannerExercise: Identifiable, Hashable {
    struct Set: Hashable, Identifiable {
        struct Config: Hashable {
            let metricLabel: String
            let metricFieldMode: ParameterFieldKind
            let weightLabel: String
        }
        let id: UUID
        var weight: Double? = 0
        var repCount: Double? = 0
        let config: Config
    }
    let id: UUID
    let exerciseId: UUID
    let name: String
    var pace: UIPacePicker.InputState
    var sets: [Set]
    
    /// Index of superset an exercise is member of.
    /// nil: exercise is not a part of superset.
    var supersetIndex: Int?
}

#if DEBUG
extension PlannerExercise {
    static func dt_deadlift(supersetIndex: Int? = nil) -> PlannerExercise {
        return PlannerExercise(
            id: UUID(),
            exerciseId: UUID(),
            name: "Deadlift",
            pace: UIPacePicker.InputState(),
            sets: [.dt_reps, .dt_reps, .dt_reps],
            supersetIndex: supersetIndex
        )
    }

    static func dt_squat(supersetIndex: Int? = nil) -> PlannerExercise {
        return PlannerExercise(
            id: UUID(),
            exerciseId: UUID(),
            name: "Squat",
            pace: UIPacePicker.InputState(),
            sets: [.dt_reps, .dt_reps, .dt_reps],
            supersetIndex: supersetIndex
        )
    }
}

extension PlannerExercise.Set {
    static var dt_mins: Self {
        PlannerExercise.Set(
            id: UUID(),
            config: .init(
                metricLabel: "mins",
                metricFieldMode: .time,
                weightLabel: "kg"
            )
        )
    }
    
    static var dt_reps: Self {
        PlannerExercise.Set(
            id: UUID(),
            config: .init(
                metricLabel: "reps",
                metricFieldMode: .reps,
                weightLabel: "kg"
            )
        )
    }
}
#endif
