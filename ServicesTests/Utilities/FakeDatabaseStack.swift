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

func makeInMemoryPeristentContainer() -> AnyPublisher<NSPersistentContainer, Error> {
    return Future { promise in
        let container = NSPersistentContainer(name: "Weights")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { _, error in
            if let error = error {
                promise(.failure(error))
            } else {
                promise(.success(container))
            }
        }
    }.eraseToAnyPublisher()
}
