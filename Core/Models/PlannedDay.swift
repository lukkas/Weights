//
//  PlannedDay.swift
//  Core
//
//  Created by Łukasz Kasperek on 16/06/2022.
//

import Foundation

public struct PlannedDay: Equatable {
    public let name: String
    public let exercises: [PlannedExercise]
    
    public init(name: String, exercises: [PlannedExercise]) {
        self.name = name
        self.exercises = exercises
    }
}

#if DEBUG
extension PlannedDay {
    static func make() -> PlannedDay {
        return PlannedDay(
            name: "A1",
            exercises: []
        )
    }
}
#endif
