//
//  NSManagedObject+Extensions.swift
//  Services
//
//  Created by Łukasz Kasperek on 10/05/2020.
//  Copyright © 2020 Łukasz Kasperek. All rights reserved.
//

import CoreData
import Foundation

extension NSManagedObjectContext {
    static var synchronousMode = false
    
    func performSaveOrRollback() {
        let perform = Self.synchronousMode
            ? self.performAndWait
            : self.perform
        perform {
            _ = self.saveOrRollback()
        }
    }
    
    func saveOrRollback() -> Bool {
        do {
            try save()
            return true
        } catch {
            rollback()
            return false
        }
    }
}
