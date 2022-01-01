//
//  TextStyle.swift
//  Core
//
//  Created by Łukasz Kasperek on 01/01/2022.
//

import SwiftUI

struct TextStyle: ViewModifier {
    enum Style {
        case listItem
    }
    
    let style: Style
    
    func body(content: Content) -> some View {
        content
            .font(font(forStyle: style))
    }
    
    private func font(forStyle style: Style) -> Font {
        switch style {
        case .listItem:
            return .system(
                size: 17,
                weight: .regular,
                design: .rounded
            )
        }
    }
}

extension View {
    func textStyle(_ style: TextStyle.Style) -> some View {
        return modifier(TextStyle(style: style))
    }
}
