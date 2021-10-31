//
//  ExerciseMetric+Displaying.swift
//  Core
//
//  Created by Łukasz Kasperek on 31/10/2021.
//  Copyright © 2021 Łukasz Kasperek. All rights reserved.
//

import Foundation
import SwiftUI

extension Exercise.Metric {
    var color: Color {
        switch self {
        case .reps: return .repsMarker
        case .duration: return .durationMarker
        }
    }
    
    var label: String {
        switch self {
        case .reps: return L10n.Common.reps
        case .duration: return L10n.Common.minutes
        }
    }
    
    var parameterFieldMode: ParameterField.Kind {
        switch self {
        case .reps: return .reps
        case .duration: return .time
        }
    }
}
