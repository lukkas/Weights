//
//  Weight.swift
//  Services
//
//  Created by Łukasz Kasperek on 10/07/2022.
//

import Foundation

public struct Weight: Codable, Equatable {
    public enum Unit: Codable {
        case kg, lbs
    }
    
    public let value: Double
    public let unit: Unit
}
