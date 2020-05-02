//
//  KeyboardAdaptive.swift
//  Core
//
//  Created by Łukasz Kasperek on 02/05/2020.
//  Copyright © 2020 Łukasz Kasperek. All rights reserved.
//

import Combine
import Foundation
import SwiftUI
import UIKit

struct KeyboardAdaptive: ViewModifier {
    @State private var bottomPadding: CGFloat = 0
    
    func body(content: Content) -> some View {
        content
            .padding(.bottom, self.bottomPadding)
            .onReceive(Publishers.keyboardHeight) { keyboardHeight in
                self.bottomPadding = keyboardHeight
        }
        .animation(.easeOut(duration: 0.25))
    }
}

extension View {
    func keyboardAdaptive() -> some View {
        ModifiedContent(content: self, modifier: KeyboardAdaptive())
    }
}
