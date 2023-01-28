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

struct LinkedCardDesign: ViewModifier {
    /// Currently only supports top and bottom.
    let edges: Edge.Set
    
    func body(content: Content) -> some View {
        content
            .background {
                LinkedRoundedRectangle(cornerRadius: 16, edges: edges)
                    .foregroundColor(.background)
            }
    }
}

private struct LinkedRoundedRectangle: Shape {
    let cornerRadius: CGFloat
    /// Currently only supports top and bottom.
    let edges: Edge.Set
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.minY + cornerRadius))
        path.addQuadCurve(
            to: CGPoint(x: rect.minX + cornerRadius, y: rect.minY),
            control: CGPoint(x: rect.minX, y: rect.minY)
        )
        if edges.contains(.top) {
            path.addLine(to: CGPoint(x: rect.midX - cornerRadius, y: rect.minY))
            path.addQuadCurve(
                to: CGPoint(x: rect.midX + cornerRadius, y: rect.minY),
                control: CGPoint(x: rect.midX, y: rect.minX + cornerRadius)
            )
        }
        path.addLine(to: CGPoint(x: rect.maxX - cornerRadius, y: rect.minY))
        path.addQuadCurve(
            to: CGPoint(x: rect.maxX, y: rect.minY + cornerRadius),
            control: CGPoint(x: rect.maxX, y: rect.minY)
        )
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - cornerRadius))
        path.addQuadCurve(
            to: CGPoint(x: rect.maxX - cornerRadius, y: rect.maxY),
            control: CGPoint(x: rect.maxX, y: rect.maxY)
        )
        if edges.contains(.bottom) {
            path.addLine(to: CGPoint(x: rect.midX + cornerRadius, y: rect.maxY))
            path.addQuadCurve(
                to: CGPoint(x: rect.midX - cornerRadius, y: rect.maxY),
                control: CGPoint(x: rect.midX, y: rect.maxY - cornerRadius)
            )
        }
        path.addLine(to: CGPoint(x: rect.minX + cornerRadius, y: rect.maxY))
        path.addQuadCurve(
            to: CGPoint(x: rect.minX, y: rect.maxY - cornerRadius),
            control: CGPoint(x: rect.minX, y: rect.maxY)
        )
        path.closeSubpath()
        return path
    }
}

extension View {
    func cardDesign() -> some View {
        return modifier(CardDesign())
    }
    
    func linkedCardDesign(edges: Edge.Set) -> some View {
        return modifier(LinkedCardDesign(edges: edges))
    }
}

#if DEBUG
struct CardDesign_Previews: PreviewProvider {
    static var previews: some View {
        Text("Some text")
            .padding()
            .linkedCardDesign(edges: .vertical)
            .cellPreview()
    }
}
#endif
