//
//  Length+Grid.swift
//  Weights
//
//  Created by Łukasz Kasperek on 21/07/2019.
//  Copyright © 2019 Łukasz Kasperek. All rights reserved.
//

import Foundation
import SwiftUI

extension Length {
    static var grid: Length { 8 }
    static func grid(_ multiplier: Length) -> Length { grid * multiplier }
}
