//
//  CGFloat+Extensions.swift
//  Core
//
//  Created by Łukasz Kasperek on 28/03/2021.
//  Copyright © 2021 Łukasz Kasperek. All rights reserved.
//

import Foundation
import UIKit

extension CGFloat {
    func clamped(to range: ClosedRange<CGFloat>) -> CGFloat {
        return CGFloat.maximum(
            range.lowerBound,
            CGFloat.minimum(range.upperBound, self)
        )
    }
}
