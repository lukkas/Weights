//
//  ParameterField.swift
//  Core
//
//  Created by Łukasz Kasperek on 08/11/2020.
//  Copyright © 2020 Łukasz Kasperek. All rights reserved.
//

import SwiftUI

enum ParameterFieldKind {
    case reps, weight, time, setsCount, distance
}

extension PickerTextField {
    func parameterField(_ kind: ParameterFieldKind) -> PickerTextField {
        return self
            .themeColor(kind.themeColor)
            .mode(kind.fieldMode)
            .jumpInterval(kind.jumpInterval)
            .minMaxRange(kind.valueRange)
    }
}

private extension ParameterFieldKind {
    var fieldMode: UIPickerTextField.Mode {
        switch self {
        case .reps, .setsCount: return .wholes
        case .time: return .time
        case .weight, .distance: return .floatingPoint
        }
    }
    
    var jumpInterval: Double? {
        switch self {
        case .reps, .setsCount: return 1
        case .time: return 5
        case .weight: return 0.25
        case .distance: return 0.5
        }
    }
    
    var valueRange: ClosedRange<Double>? {
        switch self {
        case .reps, .setsCount: return 0 ... 100
        case .time: return 0 ... 3600
        case .weight: return 0 ... 10000
        case .distance: return 0 ... 1000
        }
    }
    
    var themeColor: Color {
        switch self {
        case .reps, .setsCount: return .repsMarker
        case .weight: return .weightMarker
        case .time: return .durationMarker
        case .distance: return .distanceMarker
        }
    }
}

extension VerticalAlignment {
    enum ParameterFieldAlignment: AlignmentID {
        static func defaultValue(in context: ViewDimensions) -> CGFloat {
            return context[.center as VerticalAlignment]
        }
    }
    static let parameterFieldAlignment = VerticalAlignment(ParameterFieldAlignment.self)
}

extension View {
    func parameterFieldAligned() -> some View {
        return alignmentGuide(.parameterFieldAlignment, computeValue: { d in
            d[VerticalAlignment.lastTextBaseline] - 10
        })
    }
}

struct ParameterField_Previews: PreviewProvider {
    struct Wrapper: View {
        @State var value: Double? = nil
        
        var body: some View {
            PickerTextField(value: $value)
                .parameterField(.reps)
        }
    }
    
    static var previews: some View {
        Wrapper()
    }
}
