//
//  CardDesign.swift
//  Core
//
//  Created by Łukasz Kasperek on 11/11/2021.
//  Copyright © 2021 Łukasz Kasperek. All rights reserved.
//

import SwiftUI

struct CardDesign: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .foregroundColor(.background)
            }
    }
}

extension View {
    func cardDesign() -> some View {
        return modifier(CardDesign())
    }
}
