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

public func makeWeightsPersistentContainer() -> AnyPublisher<NSPersistentContainer, Error> {
    return Future { promise in
        DispatchQueue.global(qos: .userInitiated).async {
            let container = NSPersistentContainer(name: "Weights")
            container.loadPersistentStores { _, error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(container))
                }
            }
        }
    }.eraseToAnyPublisher()
}
