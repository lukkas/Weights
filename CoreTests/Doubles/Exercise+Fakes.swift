//
//  ExerciseDummy.swift
//  CoreTests
//
//  Created by Łukasz Kasperek on 10/05/2020.
//  Copyright © 2020 Łukasz Kasperek. All rights reserved.
//

@testable import Core
import Foundation

extension Exercise {
    static var dummy: Exercise {
        return .init(
            id: .init(),
            name: "Squat",
            metric: .reps,
            laterality: .bilateral
        )
    }
    
    static func make(count: Int = 1) -> [Exercise] {
        let names = [
            "Squat", "Bench press", "Deadlift", "Sumo deadlift", "Seal row",
            "Biecep curl", "Tricep extension", "Farmer walk"
        ]
        guard count <= names.count else {
            preconditionFailure("too litlle exercises. Do sth!")
        }
        return names.prefix(count).map { name in
            Exercise(
                id: UUID(),
                name: name,
                metric: .reps,
                laterality: .bilateral
            )
        }
    }
}
