//
//  Exercise.swift
//  Core
//
//  Created by Łukasz Kasperek on 03/05/2020.
//  Copyright © 2020 Łukasz Kasperek. All rights reserved.
//

import Foundation

public struct Exercise: Equatable, Codable {
    public enum Metric: CaseIterable, Codable {
        case reps, duration, distance
    }
    
    public enum Laterality: CaseIterable, Codable {
        case bilateral, unilateralSingle, unilateralIndividual
    }
    
    public let id: UUID
    public let name: String
    public let metric: Metric
    public let laterality: Laterality
    
    public init(
        id: UUID,
        name: String,
        metric: Exercise.Metric,
        laterality: Exercise.Laterality
    ) {
        self.id = id
        self.name = name
        self.metric = metric
        self.laterality = laterality
    }
}

extension Exercise.Metric: Identifiable {
    public var id: Self {
        return self
    }
}

extension Exercise.Laterality: Identifiable {
    public var id: Self {
        return self
    }
}

#if DEBUG
extension Exercise {
    static var dummy: Exercise {
        return .init(
            id: .init(),
            name: "Squat",
            metric: .reps,
            laterality: .bilateral
        )
    }
    
    static func make() -> Exercise {
        return make(count: 1).first!
    }
    
    static func make(count: Int) -> [Exercise] {
        let names = [
            "Squat", "Bench press", "Deadlift", "Sumo deadlift", "Seal row",
            "Biecep curl", "Tricep extension", "Farmer walk"
        ]
        guard count <= names.count else {
            preconditionFailure("too little exercises. Do sth!")
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
#endif
