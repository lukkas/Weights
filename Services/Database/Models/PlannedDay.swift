//
//  PlannedDay.swift
//  Services
//
//  Created by Łukasz Kasperek on 07/08/2022.
//

import CoreData
import Foundation

public class PlannedDay: NSManagedObject, Managed {
    @NSManaged public var name: String
    @NSManaged public var exercises: NSOrderedSet
}
