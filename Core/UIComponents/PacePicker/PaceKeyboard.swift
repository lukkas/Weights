//
//  PaceKeyboard.swift
//  Core
//
//  Created by Łukasz Kasperek on 08/05/2022.
//

import SwiftUI

struct PaceKeyboard: View {
    static let explosiveSign = "X"
    
    let onKeyTapped: (String) -> ()
    
    private let rows = Array(
        repeating: GridItem(.flexible(), spacing: 16),
        count: 3
    )
    
    var body: some View {
        LazyVGrid(columns: rows, spacing: 8) {
            Group {
                ForEach(allKeys.indices, id: \.self) { index in
                    button(allKeys[index])
                }
            }
        }
        .padding()
        .background(Color.secondaryBackground)
    }
    
    @ViewBuilder private func button(_ key: String) -> some View {
        Button(key) {
            onKeyTapped(key)
        }
        .buttonStyle(.keyboard)
    }
    
    private let allKeys: [String] = {
        let numbers = (1 ... 9).map(String.init)
        return numbers + [Self.explosiveSign, String(0)]
    }()
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
                .frame(height: 52)
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
        PaceKeyboard(onKeyTapped: { _ in })
    }
}
