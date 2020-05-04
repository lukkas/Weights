//
//  ExercisesRepository.swift
//  Services
//
//  Created by Łukasz Kasperek on 03/05/2020.
//  Copyright © 2020 Łukasz Kasperek. All rights reserved.
//

import CoreData
import Foundation

public class ExercisesRepository {
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    public func insertExercise(
        id: UUID,
        name: String,
        volumeUnit: Exercise.VolumeUnit,
        laterality: Exercise.Laterality
    ) {
        let exercise = context.insertObject() as Exercise
        exercise.id = id
        exercise.name = name
        exercise.volumeUnit = volumeUnit
        exercise.laterality = laterality
    }
    
    public func fetchExercises() -> FetchResult<Exercise> {
        let fetchRequest = Exercise.sortedFetchRequest
        return FetchResult(fetchRequest: fetchRequest)
    }
}
