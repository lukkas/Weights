//
//  PlanRepository.swift
//  Services
//
//  Created by Łukasz Kasperek on 07/08/2022.
//

import Combine
import CoreData
import Foundation

struct PlannedExerciseInsertion {
    
}

struct PlannedDayInsertion {
    func setName(_ name: String) {
        
    }
    
    func addExercise() -> PlannedExerciseInsertion {
        fatalError()
    }
}

struct PlanInsertion {
    func setName(_ name: String) {
        
    }
    
    func addDay() -> PlannedDayInsertion {
        fatalError()
    }
}

public class PlanRepository {
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    public func insertPlan(_ insertion: (NSManagedObjectContext) -> Void) {
        insertion(context)
        context.performSaveOrRollback()
    }
    
    public func autoupdatingPlans() -> AnyPublisher<[Plan], Never> {
        return Just([]).eraseToAnyPublisher()
    }
}
