//
//  NSFetchRequest+Publishers.swift
//  Services
//
//  Created by Łukasz Kasperek on 15/08/2022.
//

import Combine
import CoreData
import Foundation

extension NSManagedObjectContext {
    func autoupdatingFetchRequest<ResultType>(
        with fetchRequest: NSFetchRequest<ResultType>
    ) -> some Publisher<[ResultType], Never> {
        let first = Future<[ResultType], Never> { [context = self] promise in
            let exercises = try! context.fetch(fetchRequest)
            promise(.success(exercises))
        }
        let updates = NotificationCenter.default
            .publisher(
                for: .NSManagedObjectContextObjectsDidChange,
                object: self
            )
            .map { [context = self] notification in
                return try! context.fetch(fetchRequest)
            }
        return Publishers
            .Concatenate(prefix: first, suffix: updates)
            .eraseToAnyPublisher()
    }
}
