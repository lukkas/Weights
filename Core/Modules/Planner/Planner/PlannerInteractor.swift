//
//  PlannerInteractor.swift
//  Core
//
//  Created by Łukasz Kasperek on 26/10/2022.
//

import Foundation

protocol PlannerInteracting {
    func save(_ plan: Plan)
}

struct PlannerExercise: Identifiable, Hashable {
    struct Set: Hashable, Identifiable {
        struct Config: Hashable {
            let metricLabel: String
            let metricFieldMode: ParameterFieldKind
            let weightLabel: String
        }
        let id: UUID
        var weight: Double?
        var repCount: Double?
        let config: Config
    }
    let id: UUID
    let name: String
    var pace: UIPacePicker.InputState
    var sets: [Set]
    let createsSupersets: Bool
}

class PlannerInteractor: PlannerInteracting {
    private struct State {
        
    }
    
    func save(_ plan: Plan) {
        
    }
}
