//
//  CardDesign.swift
//  Core
//
//  Created by Łukasz Kasperek on 11/11/2021.
//  Copyright © 2021 Łukasz Kasperek. All rights reserved.
//

import SwiftUI

struct CardDesign: ViewModifier {
    let backgroundColor: Color
    let borderColor: Color?
    
    func body(content: Content) -> some View {
        content
            .background {
                shape
                    .foregroundColor(backgroundColor)
            }
            .unwrapping(borderColor) { view, borderColor in
                view.overlay {
                    shape
                        .stroke(borderColor, lineWidth: 2)
                }
            }
    }
    
    private let shape = RoundedRectangle(cornerRadius: 16, style: .continuous)
}

struct LinkedCardDesign: ViewModifier {
    /// Currently only supports top and bottom.
    let edges: Edge.Set
    let backgroundColor: Color
    let borderColor: Color?
    
    func body(content: Content) -> some View {
        content
            .background {
                shape
                    .foregroundColor(backgroundColor)
            }
            .unwrapping(borderColor) { view, borderColor in
                view.overlay {
                    shape
                        .stroke(borderColor, lineWidth: 2)
                }
            }
    }
    
    private var shape: LinkedRoundedRectangle {
        LinkedRoundedRectangle(cornerRadius: 16, edges: edges)
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
    func cardDesign(
        backgroundColor: Color = .background,
        borderColor: Color? = nil
    ) -> some View {
        return modifier(
            CardDesign(backgroundColor: backgroundColor, borderColor: borderColor)
        )
    }
    
    func linkedCardDesign(
        edges: Edge.Set,
        backgroundColor: Color = .background,
        borderColor: Color? = nil
    ) -> some View {
        return modifier(
            LinkedCardDesign(
                edges: edges,
                backgroundColor: backgroundColor,
                borderColor: borderColor
            )
        )
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
