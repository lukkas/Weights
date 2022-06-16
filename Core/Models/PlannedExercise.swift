//
//  PlannedExercise.swift
//  Core
//
//  Created by Łukasz Kasperek on 16/06/2022.
//

import Foundation

struct PlannedExercise {
    struct Variation {
        let numberOfSets: Int
        let volume: Int // reps or seconds
        let weight: Weight
    }
    
    let exercise: Exercise
    let pace: Pace?
    let variations: [Variation]
}
