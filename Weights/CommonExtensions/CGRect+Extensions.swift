//
//  CGRect+Extensions.swift
//  Weights
//
//  Created by Łukasz Kasperek on 05/01/2020.
//  Copyright © 2020 Łukasz Kasperek. All rights reserved.
//

import Foundation
import SwiftUI

extension CGRect {
    public var center: CGPoint {
        return CGPoint(
            x: midX,
            y: midY
        )
    }
}
