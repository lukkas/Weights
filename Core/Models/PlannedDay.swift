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
extension PlannedDay: Stubbable {
    typealias StubberType = PlannedDayStubber
}

var aPlannedDay: PlannedDayStubber { PlannedDay.stubber() }

struct PlannedDayStubber: Stubber {
    var name = "A1"
    var exercises = ArrayStubber<PlannedExercise>()
    
    func stub() -> PlannedDay {
        return PlannedDay(
            name: name,
            exercises: exercises.stub()
        )
    }
}
#endif
