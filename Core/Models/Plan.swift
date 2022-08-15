//
//  Plan.swift
//  Core
//
//  Created by Łukasz Kasperek on 16/06/2022.
//

import Foundation

public struct Plan {
    public let name: String
    public let days: [PlannedDay]
    
    public init(name: String, days: [PlannedDay]) {
        self.name = name
        self.days = days
    }
}

#if DEBUG
extension Plan {
    static func make() -> Plan {
        return Plan(name: "Upper-Lower", days: [])
    }
}
#endif
