//
//  ExercisesRepository.swift
//  Services
//
//  Created by Łukasz Kasperek on 03/05/2020.
//  Copyright © 2020 Łukasz Kasperek. All rights reserved.
//

import Combine
import CoreData
import Foundation

public class ExercisesRepository {
    private let context: NSManagedObjectContext
    private let currentDate: () -> Date
    
    init(
        context: NSManagedObjectContext,
        currentDate: @escaping () -> Date = Date.init
    ) {
        self.context = context
        self.currentDate = currentDate
    }
    
    public func insertExercise(
        id: UUID,
        name: String,
        metric: Exercise.Metric,
        laterality: Exercise.Laterality
    ) {
        let exercise = context.insertObject() as Exercise
        exercise.id = id
        exercise.name = name
        exercise.metric = metric
        exercise.laterality = laterality
        exercise.addedAt = currentDate()
        context.performSaveOrRollback()
    }
    
    public func autoupdatingExercises() -> AnyPublisher<[Exercise], Never> {
        let fetchRequest = Exercise.sortedFetchRequest
        let first = Future<[Exercise], Never> { [context] promise in
            let exercises = try! context.fetch(fetchRequest)
            promise(.success(exercises))
        }
        let updates = NotificationCenter.default
            .publisher(
                for: .NSManagedObjectContextObjectsDidChange,
                object: context
            )
            .map { [context] notification in
                return try! context.fetch(fetchRequest)
            }
            .eraseToAnyPublisher()
        return Publishers
            .Concatenate(prefix: first, suffix: updates)
            .eraseToAnyPublisher()
    }
    
    public func subscribeToExerciseChanges() -> AnyPublisher<[Exercise], Never> {
        NotificationCenter.default
            .publisher(
                for: .NSManagedObjectContextObjectsDidChange,
                object: context
            )
            .map { notification in
                return try! self.context.fetch(Exercise.sortedFetchRequest)
            }
            .eraseToAnyPublisher()
    }
}
