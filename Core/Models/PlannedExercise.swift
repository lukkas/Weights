//
//  PlannedExercise.swift
//  Core
//
//  Created by Łukasz Kasperek on 16/06/2022.
//

import Foundation

public struct PlannedExercise {
    public struct SetCollection {
        public let numberOfSets: Int
        public let volume: Int // reps or seconds
        public let weight: Weight
    }
    
    public let exercise: Exercise
    public let pace: Pace?
    public let variations: [SetCollection]
    public let createsSupersets: Bool
}
