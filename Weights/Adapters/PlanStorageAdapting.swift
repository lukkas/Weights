//
//  PlanStorage.swift
//  Weights
//
//  Created by Łukasz Kasperek on 07/08/2022.
//

import Combine
import Core
import CoreData
import Foundation
import Services

extension PlanRepository: PlanStoring {
    public func insert(_ plan: Core.Plan) {
        insertPlan { context in
            let insertedPlan = context.insertObject() as Services.Plan
            insertedPlan.name = plan.name
            insertedPlan.days = NSOrderedSet(array: prepareDays(for: plan, in: context))
            insertedPlan.isCurrent = plan.isCurrent
        }
    }
    
    private func prepareDays(
        for plan: Core.Plan,
        in context: NSManagedObjectContext
    ) -> [Services.PlannedDay] {
        var days = [Services.PlannedDay]()
        for modelDay in plan.days {
            let day = context.insertObject() as Services.PlannedDay
            day.name = modelDay.name
            day.exercises = NSOrderedSet(array: preparePlannedExercises(from: modelDay, in: context))
            days.append(day)
        }
        return days
    }
    
    private func preparePlannedExercises(
        from day: Core.PlannedDay,
        in context: NSManagedObjectContext
    ) -> [Services.PlannedExercise] {
        var exercises = [Services.PlannedExercise]()
        for modelExercise in day.exercises {
            let exercise = context.insertObject() as Services.PlannedExercise
            exercise.exercise = findExercise(matching: modelExercise.exercise, in: context)
            exercise.setCollections = modelExercise.setCollections.map({ $0.toServices() })
            exercise.createsSupersets = modelExercise.createsSupersets
            exercises.append(exercise)
        }
        return exercises
    }
    
    private func findExercise(
        matching exerciseToMatch: Core.Exercise,
        in context: NSManagedObjectContext
    ) -> Services.Exercise {
        let request = NSFetchRequest<Services.Exercise>(entityName: Services.Exercise.entityName)
        request.predicate = NSPredicate(format: "id == %@", exerciseToMatch.id as NSUUID)
        request.fetchLimit = 1
        let result = try! context.fetch(request)
        return result.first!
    }
    
    public var autoupdatingPlans: AnyPublisher<[Core.Plan], Never> {
        let originalPublisher = autoupdatingPlans() as AnyPublisher<[Services.Plan], _>
        return originalPublisher
            .map { databasePlans in
                databasePlans.map({ $0.toCore() })
            }
            .eraseToAnyPublisher()
    }
}
