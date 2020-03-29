//
//  InnerDepthShadow.swift
//  Core
//
//  Created by Łukasz Kasperek on 29/03/2020.
//  Copyright © 2020 Łukasz Kasperek. All rights reserved.
//

import Foundation
import SwiftUI

struct InnerDepthShadow<S: Shape>: ViewModifier {
    let shape: S
    
    func body(content: Content) -> some View {
        content
            .overlay(
                shape
                    .stroke(Color.gray, lineWidth: 4)
                    .blur(radius: 4)
                    .offset(x: 2, y: 2)
                    .mask(shape.fill(LinearGradient(.black, .clear)))
            )
            .overlay(
                shape
                    .stroke(Color.white, lineWidth: 8)
                    .blur(radius: 4)
                    .offset(x: -2, y: -2)
                    .mask(shape.fill(LinearGradient(.clear, .black)))
            )
    }
}

extension View {
    func innerDepthShadow<S: Shape>(shape: S) -> some View {
        return self.modifier(InnerDepthShadow(shape: shape))
    }
}

private extension LinearGradient {
    init(_ colors: Color...) {
        self.init(
            gradient: Gradient(colors: colors),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}
