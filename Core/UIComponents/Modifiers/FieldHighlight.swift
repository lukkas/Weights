//
//  FieldHighlight.swift
//  Core
//
//  Created by Łukasz Kasperek on 17/10/2021.
//  Copyright © 2021 Łukasz Kasperek. All rights reserved.
//

import Foundation
import SwiftUI

struct FieldHighlight: ViewModifier {
    enum Style {
        case fill, border
    }
    
    let style: Style
    let color: Color
    
    func body(content: Content) -> some View {
        content
            .background {
                switch style {
                case .fill:
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundColor(color)
                case .border:
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(color)
                }
            }
    }
}

extension View {
    func fieldHighlighted() -> some View {
        return modifier(FieldHighlight(
            style: .border, color: .red
        ))
    }
}

struct FieldHighlight_Previews: PreviewProvider {
    static var previews: some View {
        Text("Text")
            .foregroundColor(.red)
            .padding()
            .fieldHighlighted()
    }
}
