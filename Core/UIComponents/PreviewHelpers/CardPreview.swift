//
//  BoxPreview.swift
//  Core
//
//  Created by Łukasz Kasperek on 28/08/2022.
//

import Foundation
import SwiftUI

struct CardPreview: ViewModifier {
    func body(content: Content) -> some View {
        ZStack {
            Color.groupedBackground.ignoresSafeArea()
            content
                .background(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .foregroundColor(.background)
                )
                .padding(16)
        }
    }
}

extension View {
    func cardPreview() -> some View {
        return modifier(CardPreview())
    }
}
