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
    @Binding var value: String
    
    @State var viewIndex = 0
    var body: some View {
        VStack(spacing: 0) {
            TextField("", text: $value)
                .alignmentGuide(.parameterFieldAlignment, computeValue: { d in
                    d[VerticalAlignment.center]
                })
                .keyboardType(.numberPad)
                .multilineTextAlignment(.center)
                .foregroundColor(.overThemeLabel)
                .padding(.horizontal, 6)
                .padding(.vertical, 3)
                .frame(width: 50)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundColor(Color.red.opacity(0.75))
                )
            Text(label).font(.caption2)
        }
    }
}

struct ParameterField_Previews: PreviewProvider {
    struct Wrapper: View {
        @State var value: String = ""
        var body: some View {
            ParameterField(label: "Reps", value: $value)
        }
    }
    
    static var previews: some View {
        Wrapper()
    }
}
