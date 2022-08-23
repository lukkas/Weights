//
//  Weight+ModelAdapting.swift
//  Weights
//
//  Created by Łukasz Kasperek on 23/08/2022.
//

import Core
import Foundation
import Services

extension Services.Weight {
    func toCore() -> Core.Weight {
        return .init(
            value: value,
            unit: unit.toCore()
        )
    }
}

extension Core.Weight {
    func toServices() -> Services.Weight {
        return .init(
            value: value,
            unit: unit.toServices()
        )
    }
}

extension Services.Weight.Unit {
    func toCore() -> Core.Weight.Unit {
        switch self {
        case .kg: return .kg
        case .lbs: return .lbs
        }
    }
}

extension Core.Weight.Unit {
    func toServices() -> Services.Weight.Unit {
        switch self {
        case .kg: return .kg
        case .lbs: return .lbs
        }
    }
}
