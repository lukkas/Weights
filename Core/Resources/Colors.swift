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
    static var background: Color { .init("background", bundle: current) }
    static var theme: Color { .init("theme", bundle: current) }
    static var label: Color { .init("label", bundle: current) }
    static var border: Color { .init("border", bundle: current) }
}

private var current: Bundle {
    return Bundle(for: BundleToken.self)
}
private class BundleToken {}
