//
//  Weight.swift
//  Core
//
//  Created by Łukasz Kasperek on 16/06/2022.
//

import Foundation

struct Weight {
    enum Unit {
        case kg, lbs
    }
    
    let value: Double
    let unit: Unit
}
