//
//  PlannedExercise.swift
//  Core
//
//  Created by Łukasz Kasperek on 16/06/2022.
//

import Foundation

public struct PlannedExercise: Equatable {
    public struct SetCollection: Equatable {
        public let numberOfSets: Int
        public let volume: Int // reps/seconds/meters
        public let weight: Weight
    }
    
    public let exercise: Exercise
    public let pace: Pace?
    public let setCollections: [SetCollection]
    public let createsSupersets: Bool
}

#if DEBUG
extension PlannedExercise {
    static func make() -> PlannedExercise {
        return PlannedExercise(
            exercise: .make(),
            pace: nil,
            setCollections: [],
            createsSupersets: false
        )
    }
}
#endif
