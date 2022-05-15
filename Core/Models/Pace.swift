//
//  Pace.swift
//  Core
//
//  Created by Łukasz Kasperek on 25/10/2020.
//  Copyright © 2020 Łukasz Kasperek. All rights reserved.
//

import Foundation

struct Pace {
    enum Component {
        case explosive
        case number(Int)
    }
    let eccentric: Component
    let isometric: Component
    let concentric: Component
    let startingPoint: Component
}
