//
//  CellPreview.swift
//  Core
//
//  Created by Łukasz Kasperek on 25/10/2020.
//  Copyright © 2020 Łukasz Kasperek. All rights reserved.
//

import Foundation
import SwiftUI

struct CellPreview: ViewModifier {
    func body(content: Content) -> some View {
        ZStack {
            Color
                .groupedBackground
                .ignoresSafeArea()
            
            content
                .padding(.all, 16)
        }
    }
}

extension View {
    func cellPreview() -> some View {
        return modifier(CellPreview())
    }
}
