//
//  PaceKeyboard.swift
//  Core
//
//  Created by Łukasz Kasperek on 08/05/2022.
//

import SwiftUI

struct PaceKeyboard: View {
    let onKeyTapped: (Pace.Component) -> ()
    
    private let rows = Array(
        repeating: GridItem(.flexible(), spacing: 16),
        count: 3
    )
    
    var body: some View {
        LazyVGrid(columns: rows, spacing: 8) {
            Group {
                ForEach(allKeys) { key in
                    button(key)
                }
            }
        }
        .padding()
        .background(Color.secondaryBackground)
    }
    
    @ViewBuilder private func button(_ key: Pace.Component) -> some View {
        Button(key.textRepresentation) {
            onKeyTapped(key)
        }
        .buttonStyle(.keyboard)
    }
    
    private let allKeys: [Pace.Component] = {
        let numbers = (1 ... 9).map({ Pace.Component.number($0) })
        return numbers + [.explosive, .number(0)]
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
