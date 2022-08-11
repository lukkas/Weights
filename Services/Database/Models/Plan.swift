//
//  Plan.swift
//  Services
//
//  Created by Łukasz Kasperek on 10/07/2022.
//

import CoreData
import Foundation

public class Plan: NSManagedObject {
    @NSManaged public internal(set) var name: String
    @NSManaged public internal(set) var days: [PlannedDay]
}

extension Plan: Managed {
    static var defaultSortDescriptors: [NSSortDescriptor] {
        let dateSorting = NSSortDescriptor(
            keyPath: \Plan.name,
            ascending: false
        )
        return [dateSorting]
    }
}
