//
//  AppLifetimeServices.swift
//  Weights
//
//  Created by Łukasz Kasperek on 18/05/2020.
//  Copyright © 2020 Łukasz Kasperek. All rights reserved.
//

import Core
import CoreData
import Foundation
import Services

struct AppDependencies: CoreDependencies {
    var exerciseStorage: ExerciseStoring {
        return database.getExercisesRepository()
    }
    
    let database: Database
    
    init() {
        self.database = Database(persistentContainer: makeWeightsPersistentContainer())
    }
}
