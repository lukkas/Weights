//
//  PaceKeyboard.swift
//  Core
//
//  Created by Łukasz Kasperek on 08/05/2022.
//

import SwiftUI

struct PaceKeyboard: View {
    private let rows = Array(
        repeating: GridItem(.flexible(), spacing: 16),
        count: 3
    )
    
    var body: some View {
        LazyVGrid(columns: rows, spacing: 8) {
            Group {
                ForEach(1 ..< 10) { index in
                    button("\(index)")
                }
                button("X")
                button("0")
            }
            .frame(height: 52)
        }
        .padding()
        .background(Color.secondaryBackground)
    }
    
    @ViewBuilder private func button(_ text: String) -> some View {
        Button(text) {
            
        }.buttonStyle(.keyboard)
    }
}

struct KeyboardButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            Capsule()
                .foregroundColor(
                    configuration.isPressed
                    ? .fill
                    : .background
                )
            configuration.label
                .font(
                    .system(
                        size: 18,
                        weight: .medium,
                        design: .rounded
                    )
                )
        }
    }
}

extension ButtonStyle where Self == KeyboardButtonStyle {
    static var keyboard: KeyboardButtonStyle {
        return KeyboardButtonStyle()
    }
}

struct PaceKeyboard_Previews: PreviewProvider {
    static var previews: some View {
        PaceKeyboard()
    }
}
