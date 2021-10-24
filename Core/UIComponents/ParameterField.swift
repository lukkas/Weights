//
//  ParameterField.swift
//  Core
//
//  Created by Łukasz Kasperek on 08/11/2020.
//  Copyright © 2020 Łukasz Kasperek. All rights reserved.
//

import SwiftUI

struct ParameterField: View {
    enum Kind {
        case reps, weight, time, setsCount
    }
    
    let themeColor: Color
    let kind: Kind
    @Binding var value: Double?
    
    var body: some View {
        PickerTextField(
            value: $value,
            themeColor: themeColor,
            mode: kind.fieldMode,
            jumpInterval: kind.jumpInterval,
            minMaxRange: kind.valueRange
        )
            .alignmentGuide(.parameterFieldAlignment, computeValue: { d in
                d[VerticalAlignment.lastTextBaseline] - 10
            })
    }
}

private extension ParameterField.Kind {
    var fieldMode: UIPickerTextField.Mode {
        switch self {
        case .reps, .setsCount: return .wholes
        case .time: return .time
        case .weight: return .floatingPoint
        }
    }
    
    var jumpInterval: Double? {
        switch self {
        case .reps, .setsCount: return 1
        case .time: return 5
        case .weight: return 0.25
        }
    }
    
    var valueRange: ClosedRange<Double>? {
        switch self {
        case .reps, .setsCount: return 0 ... 100
        case .time: return 0 ... 3600
        case .weight: return 0 ... 10000
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

struct ParameterField_Previews: PreviewProvider {
    struct Wrapper: View {
        @State var value: Double? = nil
        
        var body: some View {
            ParameterField(
                themeColor: .weightGreen,
                kind: .reps,
                value: $value
            )
        }
    }
    
    static var previews: some View {
        Wrapper()
    }
}
