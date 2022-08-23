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
    let exerciseStorage: ExerciseStoring
    let planStorage: PlanStoring
    let database: Database
    
    init() {
        self.database = Database(
            persistentContainer: DatabaseStack.makeWeightsPersistentContainer()
        )
        self.exerciseStorage = database.getExercisesRepository()
        self.planStorage = DTPlanStorage()
    }
}
