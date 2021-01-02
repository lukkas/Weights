//
//  TestFailure.swift
//  CoreTests
//
//  Created by Łukasz Kasperek on 02/01/2021.
//  Copyright © 2021 Łukasz Kasperek. All rights reserved.
//

import Foundation

struct TestFailure: Error, CustomStringConvertible {
    let message: String
    
    var description: String {
        return message
    }
    
    init(_ message: String) {
        self.message = message
    }
}
