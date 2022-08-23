//
//  FakeDatabaseStack.swift
//  ServicesTests
//
//  Created by Łukasz Kasperek on 03/05/2020.
//  Copyright © 2020 Łukasz Kasperek. All rights reserved.
//

import Combine
import CoreData
import Foundation

public extension NSManagedObjectContext {
    static func testInMemoryContext(model: NSManagedObjectModel) -> NSManagedObjectContext {
        let coordinator = createCoordinator(with: model)
        try! coordinator.addPersistentStore(
            ofType: NSInMemoryStoreType,
            configurationName: nil,
            at: nil,
            options: nil
        )
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.persistentStoreCoordinator = coordinator
        return context
    }
    
    private static var cachedCoordinators = [NSManagedObjectModel: NSPersistentStoreCoordinator]()
    private static func createCoordinator(
        with model: NSManagedObjectModel
    ) -> NSPersistentStoreCoordinator {
        if let coordinator = cachedCoordinators[model] {
            return coordinator
        }
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        cachedCoordinators[model] = coordinator
        return coordinator
    }
}
