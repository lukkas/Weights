//
//  DatabaseStack.swift
//  Services
//
//  Created by Łukasz Kasperek on 03/05/2020.
//  Copyright © 2020 Łukasz Kasperek. All rights reserved.
//

import Combine
import CoreData
import Foundation

public enum DatabaseStack {
    public static func makeWeightsPersistentContainer() -> NSPersistentContainer {
        let container = NSPersistentContainer(
            name: "Weights",
            managedObjectModel: DatabaseModelVersion.version1.managedObjectModel()
        )
        registerValueTransformers()
        container.loadPersistentStores { _, error in
            if let error = error {
                assertionFailure("Did fail loading peristent store with: \(error)")
            }
        }
        return container
    }
    
    #if DEBUG
    static func testInMemoryContext() -> NSManagedObjectContext {
        let coordinator = testPersistentCoordinator
        for store in coordinator.persistentStores {
            let url = coordinator.url(for: store)
            try? coordinator.destroyPersistentStore(at: url, type: .inMemory)
        }
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
    
    private static let testPersistentCoordinator = NSPersistentStoreCoordinator(
        managedObjectModel: DatabaseModelVersion.version1.managedObjectModel()
    )
    #endif
    
    public static func registerValueTransformers() {
        _ = __registerOnce
    }

    private static let __registerOnce: () = {
        WeightValueTransformer.register(withName: "WeightValueTransformer")
        PaceValueTransformer.register(withName: "PaceValueTransformer")
        SetCollectionsValueTransformer.register(withName: "SetCollectionsValueTransformer")
    }()
}
