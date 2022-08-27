//
//  FrozenParameterField.swift
//  FrozenParameterField
//
//  Created by Łukasz Kasperek on 08/08/2021.
//  Copyright © 2021 Łukasz Kasperek. All rights reserved.
//

import SwiftUI

struct FrozenParameterField: View {
    let label: String
    let value: String
    let themeColor: Color
    
    var body: some View {
        Text(value)
            .textStyle(.pickerField)
            .frame(minWidth: 50, minHeight: 36)
            .background {
                RoundedRectangle(cornerRadius: 8)
                    .foregroundColor(.secondaryFill)
            }
            .alignmentGuide(.parameterFieldAlignment, computeValue: { d in
                d[VerticalAlignment.lastTextBaseline]
            })
    }
}

struct FrozenParameterField_Previews: PreviewProvider {
    static var previews: some View {
        FrozenParameterField(
            label: "reps",
            value: "8",
            themeColor: Color.weightRed
        )
    }
}
