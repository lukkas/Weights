//
//  Colors.swift
//  Core
//
//  Created by Łukasz Kasperek on 29/03/2020.
//  Copyright © 2020 Łukasz Kasperek. All rights reserved.
//

import Foundation
import SwiftUI

extension Color {
    // MARK: - Theme
    static var theme: Color { Color(UIColor.systemPink) }
    static var contrastLabel: Color { named("contrast_label") }
    static var weightRed: Color { named("weight_red") }
    static var weightBlue: Color { named("weight_blue") }
    static var weightYellow: Color { named("weight_yellow") }
    static var weightGreen: Color { named("weight_green") }
    
    // MARK: - Background
    static var background: Color { Color(UIColor.systemBackground) }
    static var secondaryBackground: Color { Color(UIColor.secondarySystemBackground) }
    static var tertiaryBackground: Color { Color(UIColor.tertiarySystemBackground) }
    
    static var groupedBackground: Color { Color(UIColor.systemGroupedBackground) }
    static var secondaryGroupedBackground: Color {
        Color(UIColor.secondarySystemGroupedBackground)
    }
    static var tertiaryGroupedBackground: Color {
        Color(UIColor.tertiarySystemGroupedBackground)
    }
    
    // MARK: - Fill
    static var fill: Color { Color(UIColor.systemFill) }
    static var secondaryFill: Color { Color(UIColor.secondarySystemFill) }
    static var tertiaryFill: Color { Color(UIColor.tertiarySystemFill) }
    static var quaternaryFill: Color { Color(UIColor.quaternarySystemFill) }
    
    // MARK: - Label
    static var label: Color { Color(UIColor.label) }
    static var secondaryLabel: Color { Color(UIColor.secondaryLabel) }
    static var tertiaryLabel: Color { Color(UIColor.tertiaryLabel) }
    static var quaternaryLabel: Color { Color(UIColor.quaternaryLabel) }
    
    // MARK: - Separator
    static var separator: Color { Color(UIColor.separator) }
    static var opaqueSeparator: Color { Color(UIColor.opaqueSeparator) }
    
    private static func named(_ name: String) -> Color {
        return .init(name, bundle: current)
    }
}

private var current: Bundle {
    return Bundle(for: BundleToken.self)
}
private class BundleToken {}
