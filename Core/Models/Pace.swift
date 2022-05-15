//
//  Pace.swift
//  Core
//
//  Created by Łukasz Kasperek on 25/10/2020.
//  Copyright © 2020 Łukasz Kasperek. All rights reserved.
//

import Foundation

struct Pace {
    enum Component: Identifiable {
        case explosive
        case number(Int)
        
        var textRepresentation: String {
            switch self {
            case .explosive:
                return "X"
            case .number(let int):
                return String(int)
            }
        }
        
        var id: String {
            return textRepresentation
        }
    }
    
    let eccentric: Component
    let isometric: Component
    let concentric: Component
    let startingPoint: Component
}
