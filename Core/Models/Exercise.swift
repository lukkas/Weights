//
//  Exercise.swift
//  Core
//
//  Created by Łukasz Kasperek on 03/05/2020.
//  Copyright © 2020 Łukasz Kasperek. All rights reserved.
//

import Foundation

public struct Exercise {
    public enum VolumeUnit {
        case reps, duration
    }
    
    public enum Laterality {
        case bilateral, unilateral, unilateralSimultanous
    }
    
    public let id: UUID
    public let name: String
    public let volumeUnit: VolumeUnit
    public let laterality: Laterality
}
