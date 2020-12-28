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
    @State private var isEditing = false
    
    var body: some View {
        VStack(spacing: 0) {
            Text(label)
                .foregroundColor(themeColor)
                .font(.system(
                        size: 11,
                        weight: .medium,
                        design: .rounded
                ))
            
            TextField(
                "",
                text: $value,
                onEditingChanged: { changed in
                    isEditing = changed
                })
                .font(.system(
                        size: 18,
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
                .frame(width: 44)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundColor(.fill)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(themeColor, lineWidth: isEditing ? 2 : 0)
                )
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
