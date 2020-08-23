//
//  Exercise.swift
//  Core
//
//  Created by Łukasz Kasperek on 03/05/2020.
//  Copyright © 2020 Łukasz Kasperek. All rights reserved.
//

import Foundation

public struct Exercise {
    public enum VolumeUnit: CaseIterable {
        case reps, duration
    }
    
    public enum Laterality: CaseIterable {
        case bilateral, unilateral
    }
    
    public let id: UUID
    public let name: String
    public let volumeUnit: VolumeUnit
    public let laterality: Laterality
    
    public init(
        id: UUID,
        name: String,
        volumeUnit: Exercise.VolumeUnit,
        laterality: Exercise.Laterality
    ) {
        self.id = id
        self.name = name
        self.volumeUnit = volumeUnit
        self.laterality = laterality
    }
}

extension Exercise.VolumeUnit: Identifiable {
    public var id: Self {
        return self
    }
}

extension Exercise.Laterality: Identifiable {
    public var id: Self {
        return self
    }
}
