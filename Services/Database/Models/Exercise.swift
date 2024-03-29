//
//  Exercise.swift
//  Services
//
//  Created by Łukasz Kasperek on 03/05/2020.
//  Copyright © 2020 Łukasz Kasperek. All rights reserved.
//

import CoreData
import Foundation

public class Exercise: NSManagedObject {
    @objc public enum Laterality: Int16 {
        case bilateral = 0
        case unilateralSingle
        case unilateralIndividual
    }
    
    @objc public enum Metric: Int16 {
        case reps = 0
        case duration
        case distance
    }
    
    @NSManaged public internal(set) var id: UUID
    @NSManaged public internal(set) var name: String
    @NSManaged public internal(set) var addedAt: Date
    @NSManaged public internal(set) var laterality: Laterality
    @NSManaged public internal(set) var metric: Metric
}

extension Exercise: Managed {
    public static var defaultSortDescriptors: [NSSortDescriptor] {
        let dateSorting = NSSortDescriptor(
            keyPath: \Exercise.addedAt,
            ascending: false
        )
        return [dateSorting]
    }
}
