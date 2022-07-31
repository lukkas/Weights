//
//  PlannedExercise.swift
//  Services
//
//  Created by Łukasz Kasperek on 10/07/2022.
//

import CoreData
import Foundation

public class PlannedExercise: NSManagedObject {
    public struct SetCollection: Codable {
        public let numberOfSets: Int
        public let volume: Int // reps/seconds/meters
        public let weight: Weight
    }
    
    @NSManaged public internal(set) var exercise: Exercise
}
