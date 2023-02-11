//
//  PlannedExercise.swift
//  Services
//
//  Created by Łukasz Kasperek on 10/07/2022.
//

import CoreData
import Foundation

public class PlannedExercise: NSManagedObject, Managed {
    public class Set: NSObject, Codable {
        public let volume: Int // reps/seconds/meters
        public let weight: Weight
        
        public init(volume: Int, weight: Weight) {
            self.volume = volume
            self.weight = weight
        }
    }
    
    @NSManaged public var exercise: Exercise
    @NSManaged public var pace: Pace?
    @NSManaged public var sets: [Set]
    @NSManaged public var createsSupersets: Bool
}
