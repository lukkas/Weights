//
//  ParameterField.swift
//  Core
//
//  Created by Łukasz Kasperek on 08/11/2020.
//  Copyright © 2020 Łukasz Kasperek. All rights reserved.
//

import SwiftUI

struct ParameterField: View {
    let themeColor: Color
    //    let increment: Float = 1
    @Binding var value: Double?
    
    var body: some View {
        PickerTextField(value: $value, themeColor: themeColor)
            .alignmentGuide(.parameterFieldAlignment, computeValue: { d in
                d[VerticalAlignment.lastTextBaseline] - 10
            })
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
                value: $value
            )
        }
    }
    
    static var previews: some View {
        Wrapper()
    }
}
