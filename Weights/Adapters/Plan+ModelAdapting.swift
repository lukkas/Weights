//
//  Plan+ModelAdapting.swift
//  Weights
//
//  Created by Łukasz Kasperek on 15/08/2022.
//

import Core
import Foundation
import Services

extension Services.Plan {
    func toCore() -> Core.Plan {
        return Core.Plan(
            name: name,
            days: []
        )
    }
}
