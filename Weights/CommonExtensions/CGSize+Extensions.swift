//
//  CGSize+Extensions.swift
//  Weights
//
//  Created by Łukasz Kasperek on 03/01/2020.
//  Copyright © 2020 Łukasz Kasperek. All rights reserved.
//

import SwiftUI

extension CGSize {
    public var shorterDimension: CGFloat {
        return min(width, height)
    }
}
