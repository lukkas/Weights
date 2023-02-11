//
//  PlannedExercise.swift
//  Core
//
//  Created by Łukasz Kasperek on 16/06/2022.
//

import Foundation

public struct PlannedExercise: Equatable {
    public struct Set: Equatable {
        public let volume: Int // reps/seconds/meters
        public let weight: Weight
        
        public init(volume: Int, weight: Weight) {
            self.volume = volume
            self.weight = weight
        }
    }
    
    public let exercise: Exercise
    public let pace: Pace?
    public let sets: [Set]
    
    /// Creates superset with item behind it in the exercises list.
    /// Assuming there're two supersets next to each other,
    /// their createsSupersets properties
    /// will look like: true, false, true, false
    /// For four exercises gigaset it will be: true, true, true, false.
    public let createsSupersets: Bool
    
    public init(
        exercise: Exercise,
        pace: Pace? = nil,
        sets: [PlannedExercise.Set],
        createsSupersets: Bool
    ) {
        self.exercise = exercise
        self.pace = pace
        self.sets = sets
        self.createsSupersets = createsSupersets
    }
}

#if DEBUG
extension PlannedExercise: Stubbable {
    typealias StubberType = PlannedExerciseStubber
}

var aPlannedExercise: PlannedExerciseStubber { PlannedExercise.stubber() }

struct PlannedExerciseStubber: Stubber {
    var exercise: ExerciseStubber = .init()
    var pace: Pace?
    var sets: [PlannedExercise.Set] = []
    var createsSupersets: Bool = false
    
    
    func stub() -> PlannedExercise {
        return PlannedExercise(
            exercise: exercise.stub(),
            pace: pace,
            sets: sets,
            createsSupersets: createsSupersets
        )
    }
}
#endif
