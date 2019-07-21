//
//  ExercideCreationViewModel.swift
//  Weights
//
//  Created by Łukasz Kasperek on 01/07/2019.
//  Copyright © 2019 Łukasz Kasperek. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

class ExerciseCreationViewModel: BindableObject {
    var willChange = PassthroughSubject<Void, Never>()
    
    var name: String = "" {
        didSet { willChange.send() }
    }
    var lateralityModel: QuickSelectorModel = initialLateralityModel()
    var muscleGroupModel: QuickSelectorModel = initialMuscleGroupModel()
    var quantityMetricModel: QuickSelectorModel = initialQuantityMetricModel()
}

private extension ExerciseCreationViewModel {
    static func initialLateralityModel() -> QuickSelectorModel {
        QuickSelectorModel(
            title: "Laterality",
            options: Laterality.allCases.map({
                QuickSelectorModel.Option(
                    id: $0.rawValue,
                    title: $0.name
                )
            })
        )
    }
    
    static func initialMuscleGroupModel() -> QuickSelectorModel {
        QuickSelectorModel(
            title: "Muscle Group",
            options: MuscleGroup.allCases.map({
                QuickSelectorModel.Option(
                    id: $0.rawValue,
                    title: $0.name
                )
            })
        )
    }
    
    static func initialQuantityMetricModel() -> QuickSelectorModel {
        return QuickSelectorModel(
            title: "Quantity Metric",
            options: QuantityMetric.allCases.map({
                QuickSelectorModel.Option(
                    id: $0.rawValue,
                    title: $0.name
                )
            })
        )
    }
}

private extension Laterality {
    var name: String {
        switch self {
        case .unilateral: return "Unilateral"
        case .bilateral: return "Bilateral"
        case .independentBilateral: return "Independent bilateral"
        }
    }
}

private extension MuscleGroup {
    var name: String {
        switch self {
        case .core: return "Core"
        case .back: return "Back"
        case .chest: return "Chest"
        case .shoulders: return "Shoulders"
        case .bicep: return "Bicep"
        case .tricep: return "Tricep"
        case .legs: return "Legs"
        case .fullBody: return "Full Body"
        case .other: return "Other"
        }
    }
}

private extension QuantityMetric {
    var name: String {
        switch self {
        case .reps: return "Reps"
        case .seconds: return "Seconds"
        }
    }
}
