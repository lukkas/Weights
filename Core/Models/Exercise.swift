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
extension Exercise: Buildable {
    typealias BuilderType = ExerciseBuilder
}

struct ExerciseBuilder: Builder {
    private var name: String = "Squat"
    private var metric: Exercise.Metric = .reps
    private var laterality: Exercise.Laterality = .bilateral
    
    func build() -> Exercise {
        return Exercise(
            id: UUID(),
            name: name,
            metric: metric,
            laterality: laterality
        )
    }
    
    func withName(_ name: String) -> ExerciseBuilder {
        var copy = self
        copy.name = name
        return copy
    }
}
#endif
