//
//  Exercise.swift
//  Weights
//
//  Created by Łukasz Kasperek on 18/05/2020.
//  Copyright © 2020 Łukasz Kasperek. All rights reserved.
//

import Core
import Foundation
import Services

extension Core.Exercise.Laterality {
    func toServices() -> Services.Exercise.Laterality {
        switch self {
        case .bilateral: return .bilateral
        case .unilateralSingle: return .unilateralSingle
        case .unilateralIndividual: return .unilateralIndividual
        }
    }
}

extension Services.Exercise.Laterality {
    func toCore() -> Core.Exercise.Laterality {
        switch self {
        case .bilateral: return .bilateral
        case .unilateralSingle: return .unilateralSingle
        case .unilateralIndividual: return .unilateralIndividual
        }
    }
}

extension Core.Exercise.Metric {
    func toServices() -> Services.Exercise.Metric {
        switch self {
        case .reps: return .reps
        case .duration: return .duration
        }
    }
}

extension Services.Exercise.Metric {
    func toCore() -> Core.Exercise.Metric {
        switch self {
        case .reps: return .reps
        case .duration: return .duration
        }
    }
}

extension Services.Exercise {
    func toCore() -> Core.Exercise {
        return .init(
            id: id,
            name: name,
            metric: metric.toCore(),
            laterality: laterality.toCore()
        )
    }
}
