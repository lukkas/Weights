//
//  PlannedExercise.swift
//  Services
//
//  Created by Łukasz Kasperek on 10/07/2022.
//

import CoreData
import Foundation

public class PlannedExercise: NSManagedObject, Managed {
    public class SetCollection: NSObject, Codable {
        public let numberOfSets: Int
        public let volume: Int // reps/seconds/meters
        public let weight: Weight
        
        public init(numberOfSets: Int, volume: Int, weight: Weight) {
            self.numberOfSets = numberOfSets
            self.volume = volume
            self.weight = weight
        }
    }
    
    @NSManaged public var exercise: Exercise
    @NSManaged public var pace: Pace?
    @NSManaged public var setCollections: [SetCollection]
    @NSManaged public var createsSupersets: Bool
}
