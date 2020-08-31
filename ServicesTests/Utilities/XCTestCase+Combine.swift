//
//  XCTestCase+Combine.swift
//  ServicesTests
//
//  Created by Łukasz Kasperek on 03/05/2020.
//  Copyright © 2020 Łukasz Kasperek. All rights reserved.
//

import Combine
import Foundation
import XCTest

extension XCTestCase {
    func awaitValue<T, F: Error>(
        _ publisher: AnyPublisher<T, F>,
        file: StaticString = #filePath,
        line: UInt = #line
    ) throws -> T {
        let expectation = self.expectation(description: "\(publisher) should emit value")
        var receivedValue: T?
        var cancellable: AnyCancellable? = publisher.sink(
            receiveCompletion: { _ in },
            receiveValue: { value in
                receivedValue = value
                expectation.fulfill()
        })
        wait(for: [expectation], timeout: 1)
        cancellable = nil
        return try XCTUnwrap(receivedValue)
    }
}
