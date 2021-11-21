//
//  ArrayMatching.swift
//  CoreTests
//
//  Created by Łukasz Kasperek on 21/11/2021.
//  Copyright © 2021 Łukasz Kasperek. All rights reserved.
//

import Foundation
import XCTest

func XCTAssertMatches<T, U>(
    _ lhs: [T], _ rhs: [U],
    match: (T, U) -> Void,
    _ message: @autoclosure () -> String = "",
    file: StaticString = #filePath, line: UInt = #line
) {
    guard lhs.count == rhs.count else {
        XCTFail("\(lhs.count) is not equal to \(rhs.count)", file: file, line: line)
        return
    }
    for (l, r) in zip(lhs, rhs) {
        match(l, r)
    }
}
