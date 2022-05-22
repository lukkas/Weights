//
//  Pace.swift
//  Core
//
//  Created by Łukasz Kasperek on 25/10/2020.
//  Copyright © 2020 Łukasz Kasperek. All rights reserved.
//

import Foundation

struct Pace {
    enum Component: Equatable {
        case explosive
        case number(Int)
    }
    
    let eccentric: Component
    let isometric: Component
    let concentric: Component
    let startingPoint: Component
}

extension Pace.Component: ExpressibleByIntegerLiteral {
    init(integerLiteral value: Int) {
        self = .number(value)
    }
}

extension Pace.Component {
    var textRepresentation: String {
        switch self {
        case .explosive:
            return "X"
        case .number(let int):
            return String(int)
        }
    }
    
    init?(textRepresentation: String) {
        if let number = Int(textRepresentation), 0 ... 9 ~= number {
            self = .number(number)
        } else if textRepresentation == Self.explosive.textRepresentation {
            self = .explosive
        } else {
            return nil
        }
    }
}
