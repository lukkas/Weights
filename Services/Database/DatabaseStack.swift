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

public func makeWeightsPersistentContainer() -> NSPersistentContainer {
    let container = NSPersistentContainer(
        name: "Weights",
        managedObjectModel: DatabaseModelVersion.version1.managedObjectModel()
    )
    container.loadPersistentStores { _, error in
        if let error = error {
            assertionFailure("Did fail loading peristent store with: \(error)")
        }
    }
    return container
}

private func registerValueTransformers() {
    _ = __registerOnce
}

private let __registerOnce: () = {
    WeightValueTransformer.register(withName: "WeightValueTransformer")
    PaceValueTransformer.register(withName: "PaceValueTransformer")
    SetCollectionsValueTransformer.register(withName: "SetCollectionsValueTransformer")
}()
