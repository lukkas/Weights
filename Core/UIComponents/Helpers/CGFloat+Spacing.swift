//
//  CGFloat+Spacing.swift
//  Core
//
//  Created by Łukasz Kasperek on 18/12/2022.
//

import Foundation

extension CGFloat {
    static func grid(_ multiplier: CGFloat) -> CGFloat {
        return multiplier * 8
    }
}
