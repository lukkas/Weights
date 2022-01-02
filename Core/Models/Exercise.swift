//
//  Exercise.swift
//  Core
//
//  Created by Łukasz Kasperek on 03/05/2020.
//  Copyright © 2020 Łukasz Kasperek. All rights reserved.
//

import Foundation

public struct Exercise: Equatable {
    public enum Metric: CaseIterable {
        case reps, duration
    }
    
    public enum Laterality: CaseIterable {
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
