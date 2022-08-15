//
//  NSManagedObjectContext+Managed.swift
//  Services
//
//  Created by Łukasz Kasperek on 03/05/2020.
//  Copyright © 2020 Łukasz Kasperek. All rights reserved.
//

import CoreData
import Foundation

public extension NSManagedObjectContext {
    func insertObject<A: NSManagedObject>() -> A where A: Managed {
        guard let inserted = NSEntityDescription.insertNewObject(
            forEntityName: A.entityName,
            into: self
        ) as? A else {
            fatalError("Wrong object type")
        }
        return inserted
    }
}
