//
//  Plan.swift
//  Services
//
//  Created by Łukasz Kasperek on 10/07/2022.
//

import CoreData
import Foundation

public class Plan: NSManagedObject {
    @NSManaged public var name: String
    @NSManaged public var days: [PlannedDay]
}

extension Plan: Managed {
    public static var defaultSortDescriptors: [NSSortDescriptor] {
        let dateSorting = NSSortDescriptor(
            keyPath: \Plan.name,
            ascending: false
        )
        return [dateSorting]
    }
}