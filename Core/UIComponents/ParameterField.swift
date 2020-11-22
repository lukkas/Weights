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
        HStack(alignment: .bottom, spacing: 4) {
            TextField("Add", text: $value)
                .font(.system(
                        size: 18,
                        weight: .semibold,
                        design: .rounded
                ))
                .alignmentGuide(.parameterFieldAlignment, computeValue: { d in
                    d[VerticalAlignment.center]
                })
                .keyboardType(.numberPad)
                .multilineTextAlignment(.center)
                .foregroundColor(.contrastLabel)
                .padding(.horizontal, 6)
                .padding(.vertical, 3)
                .frame(width: 50)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(themeColor)
                )
            Text(label)
                .foregroundColor(.secondaryLabel)
                .font(.system(
                        size: 12,
                        weight: .medium,
                        design: .rounded
                ))
                .offset(y: -2)
        }
    }
}

struct ParameterField_Previews: PreviewProvider {
    struct Wrapper: View {
        @State var value: String = "2"
        var body: some View {
            ParameterField(
                label: "reps",
                themeColor: .weightBlue,
                value: $value
            )
        }
    }
    
    static var previews: some View {
        Wrapper()
    }
}
