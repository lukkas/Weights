//
//  TextStyle.swift
//  Core
//
//  Created by Łukasz Kasperek on 01/01/2022.
//

import SwiftUI
import UIKit

struct TextStyle: ViewModifier {
    enum Style {
        case listItem
        case largeSectionTitle
        case sectionTitle
        case collectionPlaceholderTitle
        case collectionPlaceholderSubtitle
        case pickerField
        case pickerAccessory
        case mediumButton
        case largeButton
    }
    
    let style: Style
    
    func body(content: Content) -> some View {
        content
            .font(font(for: style))
            .foregroundColor(labelColor(for: style))
    }
    
    private func font(for style: Style) -> Font {
        switch style {
        case .listItem:
            return .system(size: 16, weight: .regular, design: .rounded)
        case .largeSectionTitle:
            return .system(size: 24, weight: .semibold, design: .rounded)
        case .sectionTitle:
            return .system(size: 18, weight: .semibold, design: .rounded)
        case .collectionPlaceholderTitle:
            return .system(size: 32, weight: .medium, design: .rounded)
        case .collectionPlaceholderSubtitle:
            return .system(size: 16, weight: .regular, design: .rounded)
        case .pickerField:
            return .system(size: 18, weight: .semibold, design: .rounded)
        case .pickerAccessory:
            return .system(size: 15, weight: .medium, design: .rounded)
        case .mediumButton:
            return .system(size: 16, weight: .medium, design: .rounded)
        case .largeButton:
            return .system(size: 18, weight: .medium, design: .rounded)
        }
    }
    
    private func labelColor(for style: Style) -> Color? {
        switch style {
        case .collectionPlaceholderSubtitle:
            return .secondaryLabel
        default:
            return nil
        }
    }
}

extension View {
    func textStyle(_ style: TextStyle.Style) -> some View {
        return modifier(TextStyle(style: style))
    }
}

extension UIFont {
    static func forStyle(_ style: Core.TextStyle.Style) -> UIFont {
        switch style {
        case .listItem:
            return .systemFont(ofSize: 17, weight: .regular)
        case .largeSectionTitle:
            return .rounded(ofSize: 24, weight: .semibold)
        case .sectionTitle:
            return .rounded(ofSize: 18, weight: .semibold)
        case .collectionPlaceholderTitle:
            return .rounded(ofSize: 32, weight: .medium)
        case .collectionPlaceholderSubtitle:
            return .rounded(ofSize: 16, weight: .regular)
        case .pickerField:
            return .rounded(ofSize: 18, weight: .semibold)
        case .pickerAccessory:
            return .rounded(ofSize: 15, weight: .medium)
        case .mediumButton:
            return .rounded(ofSize: 16, weight: .medium)
        case .largeButton:
            return .rounded(ofSize: 18, weight: .medium)
        }
    }
}
