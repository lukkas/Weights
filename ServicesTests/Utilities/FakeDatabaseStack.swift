//
//  FakeDatabaseStack.swift
//  ServicesTests
//
//  Created by Łukasz Kasperek on 12/08/2022.
//

import CoreData
import Foundation
import TestUtilities
@testable import Services

extension NSManagedObjectContext {
    static func weightsTestContext() -> NSManagedObjectContext {
        let model = DatabaseModelVersion.version1.managedObjectModel()
        return testInMemoryContext(model: model)
    }
}
