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
        
        public init(numberOfSets: Int, volume: Int, weight: Weight) {
            self.numberOfSets = numberOfSets
            self.volume = volume
            self.weight = weight
        }
    }
    
    public let exercise: Exercise
    public let pace: Pace?
    public let setCollections: [SetCollection]
    public let createsSupersets: Bool
    
    public init(
        exercise: Exercise,
        pace: Pace? = nil,
        setCollections: [PlannedExercise.SetCollection],
        createsSupersets: Bool
    ) {
        self.exercise = exercise
        self.pace = pace
        self.setCollections = setCollections
        self.createsSupersets = createsSupersets
    }
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
