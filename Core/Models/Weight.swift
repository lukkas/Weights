//
//  Weight.swift
//  Core
//
//  Created by Łukasz Kasperek on 16/06/2022.
//

import Foundation

public struct Weight: Hashable {
    public enum Unit {
        case kg, lbs
    }
    
    public let value: Double
    public let unit: Unit
    
    public init(value: Double, unit: Weight.Unit) {
        self.value = value
        self.unit = unit
    }
}
