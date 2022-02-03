//
//  OuterDepthShadow.swift
//  Core
//
//  Created by Łukasz Kasperek on 29/03/2020.
//  Copyright © 2020 Łukasz Kasperek. All rights reserved.
//

import Foundation
import SwiftUI

struct OuterDepthShadow: ViewModifier {
    func body(content: Content) -> some View {
        content
            .shadow(
                color: Color.black.opacity(0.1),
                radius: 8, x: 4, y: 4
            )
            .shadow(
                color: Color.white.opacity(0.7),
                radius: 8, x: -2, y: -2
            )
//            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 2, y: 2)
    }
}

extension View {
    func outerDepthShadow() -> some View {
        return modifier(OuterDepthShadow())
    }
}

struct OuterDepthShadow_Previews: PreviewProvider {
    static var previews: some View {
        Text("Text")
            .foregroundColor(.contrastLabel)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16.0)
                    .foregroundColor(.accentColor)
            )
            .outerDepthShadow()
            .frame(width: 200, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
            .background(Color.background)
    }
}
