//
//  Color+UIColor.swift
//  Weights
//
//  Created by Łukasz Kasperek on 22/06/2019.
//  Copyright © 2019 Łukasz Kasperek. All rights reserved.
//

import Foundation
import SwiftUI
import UIKit

extension Color {
    static func fromUIColor(_ uiColor: UIColor) -> Color {
        var redFloat: CGFloat = 0
        var greenFloat: CGFloat = 0
        var blueFloat: CGFloat = 0
        var alpha: CGFloat = 0
        uiColor.getRed(&redFloat, green: &greenFloat, blue: &blueFloat, alpha: &alpha)
        return self.init(
            .sRGB,
            red: Double(redFloat),
            green: Double(greenFloat),
            blue: Double(blueFloat),
            opacity: Double(alpha)
        )
    }
}
