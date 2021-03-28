//
//  FloatingPoint+Extensions.swift
//  Core
//
//  Created by Łukasz Kasperek on 28/03/2021.
//  Copyright © 2021 Łukasz Kasperek. All rights reserved.
//

import Foundation

extension FloatingPoint {
    func scaled(
        from sourceRange: Range<Self>,
        to targetRange: Range<Self>,
        invert: Bool = false
    ) -> Self {
        let sourceSpan = sourceRange.span
        let percentOfSelfInSourceRange = invert
            ? (sourceRange.upperBound - self) / sourceSpan
            : (self - sourceRange.lowerBound) / sourceSpan
        return targetRange.lowerBound + percentOfSelfInSourceRange * targetRange.span
    }
}

extension Range where Bound: Numeric {
    var span: Bound {
        return upperBound - lowerBound
    }
}
