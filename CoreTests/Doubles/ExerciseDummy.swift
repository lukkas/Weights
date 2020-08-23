//
//  ExerciseDummy.swift
//  CoreTests
//
//  Created by Łukasz Kasperek on 10/05/2020.
//  Copyright © 2020 Łukasz Kasperek. All rights reserved.
//

@testable import Core
import Foundation

extension Exercise {
    static var dummy: Exercise {
        return .init(
            id: .init(),
            name: "Squat",
            volumeUnit: .reps,
            laterality: .bilateral
        )
    }
}
