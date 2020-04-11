//
//  Length+Grid.swift
//  Weights
//
//  Created by Łukasz Kasperek on 21/07/2019.
//  Copyright © 2019 Łukasz Kasperek. All rights reserved.
//

import UIKit

extension CGFloat {
    static var grid: Self { 8 }
    static func grid(_ multiplier: Self) -> Self { grid * multiplier }
}
