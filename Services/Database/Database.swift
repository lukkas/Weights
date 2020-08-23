//
//  Database.swift
//  Services
//
//  Created by Łukasz Kasperek on 03/05/2020.
//  Copyright © 2020 Łukasz Kasperek. All rights reserved.
//

import CoreData
import Foundation

public class Database {
    private let persistentContainer: NSPersistentContainer
    
    public init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
    }
    
    public func getExercisesRepository() -> ExercisesRepository {
        return ExercisesRepository(context: persistentContainer.viewContext)
    }
}
