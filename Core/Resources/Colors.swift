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
    static var background: Color { named("background") }
    static var primaryElement: Color { named("primary_element") }
    static var theme: Color { named("theme") }
    static var label: Color { named("label") }
    static var overThemeLabel: Color { named("over_theme_label") }
    static var border: Color { named("border") }
    
    private static func named(_ name: String) -> Color {
        return .init(name, bundle: current)
    }
}

private var current: Bundle {
    return Bundle(for: BundleToken.self)
}
private class BundleToken {}
