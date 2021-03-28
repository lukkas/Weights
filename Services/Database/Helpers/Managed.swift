//
//  Managed.swift
//  Services
//
//  Created by Łukasz Kasperek on 03/05/2020.
//  Copyright © 2020 Łukasz Kasperek. All rights reserved.
//

import CoreData
import Foundation

protocol Managed: NSFetchRequestResult {
    static var entity: NSEntityDescription { get }
    static var entityName: String { get }
    static var defaultSortDescriptors: [NSSortDescriptor] { get }
    static var defaultPredicate: NSPredicate { get }
}

extension Managed where Self: NSManagedObject {
    static var entity: NSEntityDescription { entity() }
    static var entityName: String { entity.name! }
    static var defaultSortDescriptors: [NSSortDescriptor] { [] }
    static var defaultPredicate: NSPredicate { NSPredicate(value: true) }
    
    static var sortedFetchRequest: NSFetchRequest<Self> {
        let request = NSFetchRequest<Self>(entityName: entityName)
        request.sortDescriptors = defaultSortDescriptors
        request.predicate = defaultPredicate
        return request
    }
}
