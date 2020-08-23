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
        case .unilateral: return .unilateral
        case .bilateral: return .bilateral
        }
    }
}

extension Services.Exercise.Laterality {
    func toCore() -> Core.Exercise.Laterality {
        switch self {
        case .unilateral: return .unilateral
        case .bilateral: return .bilateral
        }
    }
}

extension Core.Exercise.VolumeUnit {
    func toServices() -> Services.Exercise.VolumeUnit {
        switch self {
        case .reps: return .reps
        case .duration: return .duration
        }
    }
}

extension Services.Exercise.VolumeUnit {
    func toCore() -> Core.Exercise.VolumeUnit {
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
            volumeUnit: volumeUnit.toCore(),
            laterality: laterality.toCore()
        )
    }
}
