//
//  Plan.swift
//  Core
//
//  Created by Łukasz Kasperek on 16/06/2022.
//

import Foundation

public struct Plan: Equatable {
    public let id: UUID
    public let name: String
    public let days: [PlannedDay]
    public let isCurrent: Bool
    
    public init(
        id: UUID,
        name: String,
        days: [PlannedDay],
        isCurrent: Bool
    ) {
        self.id = id
        self.name = name
        self.days = days
        self.isCurrent = isCurrent
    }
}

#if DEBUG
extension Plan: Stubbable {
    typealias StubberType = PlanStubber
}

var aPlan: PlanStubber { Plan.stubber() }

struct PlanStubber: Stubber {
    typealias StubbableType = Plan
    
    var name: String = "Upper - Lower"
    var days = ArrayStubber<PlannedDay>()
    var isCurrent = false
    
    func stub() -> Plan {
        return Plan(
            id: UUID(),
            name: name,
            days: days.stub(),
            isCurrent: isCurrent
        )
    }
}
#endif
