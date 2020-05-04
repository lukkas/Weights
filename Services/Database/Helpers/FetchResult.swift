//
//  FetchResult.swift
//  Services
//
//  Created by Łukasz Kasperek on 03/05/2020.
//  Copyright © 2020 Łukasz Kasperek. All rights reserved.
//

import CoreData
import Foundation

public class FetchResult<T: NSManagedObject> {
    public var objects: [T] {
        do {
            return try fetchRequest.execute()
        } catch {
            return []
        }
    }
    
    private let fetchRequest: NSFetchRequest<T>
    
    init(fetchRequest: NSFetchRequest<T>) {
        self.fetchRequest = fetchRequest
    }
}
