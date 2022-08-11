//
//  PlannedDay.swift
//  Services
//
//  Created by Łukasz Kasperek on 07/08/2022.
//

import CoreData
import Foundation

public class PlannedDay: NSManagedObject {
    @NSManaged public internal(set) var name: String
    @NSManaged public internal(set) var exercises: [PlannedExercise]
}
