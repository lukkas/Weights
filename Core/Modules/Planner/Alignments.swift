//
//  Alignments.swift
//  Alignments
//
//  Created by Łukasz Kasperek on 14/08/2021.
//  Copyright © 2021 Łukasz Kasperek. All rights reserved.
//

import Foundation
import SwiftUI

extension HorizontalAlignment {
    enum WeightAlignment: AlignmentID {
        static func defaultValue(in context: ViewDimensions) -> CGFloat {
            return context[.center as HorizontalAlignment]
        }
    }
    static let weightAlignment = HorizontalAlignment(WeightAlignment.self)
    
    enum RepsAlignment: AlignmentID {
        static func defaultValue(in context: ViewDimensions) -> CGFloat {
            return context[.center as HorizontalAlignment]
        }
    }
    static let repsAlignment = HorizontalAlignment(RepsAlignment.self)
}


