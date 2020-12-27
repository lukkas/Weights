//
//  ParameterField.swift
//  Core
//
//  Created by Łukasz Kasperek on 08/11/2020.
//  Copyright © 2020 Łukasz Kasperek. All rights reserved.
//

import SwiftUI

extension VerticalAlignment {
    enum ParameterFieldAlignment: AlignmentID {
        static func defaultValue(in context: ViewDimensions) -> CGFloat {
            return context[.center as VerticalAlignment]
        }
    }
    static let parameterFieldAlignment = VerticalAlignment(ParameterFieldAlignment.self)
}

struct ParameterField: View {
    let label: String
    let themeColor: Color
    @Binding var value: String
    
    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 0) {
            TextField("", text: $value)
                .font(.system(
                        size: 20,
                        weight: .semibold,
                        design: .rounded
                ))
                .foregroundColor(themeColor)
                .alignmentGuide(.parameterFieldAlignment, computeValue: { d in
                    d[VerticalAlignment.center]
                })
                .keyboardType(.numberPad)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 6)
                .padding(.vertical, 3)
                .frame(width: 50)
            Text(label)
                .foregroundColor(.secondaryLabel)
                .font(.system(
                        size: 12,
                        weight: .medium,
                        design: .rounded
                ))
        }
    }
    
    
}

struct ParameterField_Previews: PreviewProvider {
    struct Wrapper: View {
        @State var value: String = "2"
        
        var body: some View {
            ParameterField(
                label: "reps",
                themeColor: .weightGreen,
                value: $value
            )
        }
    }
    
    static var previews: some View {
        Wrapper()
    }
}
