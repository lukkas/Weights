//
//  PlainButtonStyle.swift
//  Core
//
//  Created by Łukasz Kasperek on 11/04/2020.
//  Copyright © 2020 Łukasz Kasperek. All rights reserved.
//

import Foundation
import SwiftUI

struct PlainButtonStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 2, y: 2)
    }
}

extension View {
    func plainButtonStyle() -> some View {
        return modifier(PlainButtonStyle())
    }
}
