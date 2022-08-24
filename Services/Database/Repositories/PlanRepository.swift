//
//  PlanRepository.swift
//  Services
//
//  Created by Łukasz Kasperek on 07/08/2022.
//

import Combine
import CoreData
import Foundation

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
        let request = Plan.sortedFetchRequest
        request.returnsObjectsAsFaults = false
        return context
            .autoupdatingFetchRequest(with: request)
            .eraseToAnyPublisher()
    }
}
