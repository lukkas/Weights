//
//  PlannedExercise.swift
//  Services
//
//  Created by Łukasz Kasperek on 10/07/2022.
//

import CoreData
import Foundation

public class PlannedExercise: NSManagedObject {
    public class SetCollection: NSObject, Codable {
        public let numberOfSets: Int
        public let volume: Int // reps/seconds/meters
        public let weight: Weight
    }
    
    @NSManaged public internal(set) var exercise: Exercise
    @NSManaged public internal(set) var pace: Pace?
    @NSManaged public internal(set) var setCollections: [SetCollection]
    @NSManaged public internal(set) var createsSupersets: Bool
}
