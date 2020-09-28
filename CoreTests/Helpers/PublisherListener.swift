//
//  PublisherListener.swift
//  CoreTests
//
//  Created by Łukasz Kasperek on 28/09/2020.
//  Copyright © 2020 Łukasz Kasperek. All rights reserved.
//

import Foundation
import Combine

class PublisherListener<Output, Failure: Error> {
    private let publisher: AnyPublisher<Output, Failure>
    private var subscription: AnyCancellable?
    
    init(
        publisher: AnyPublisher<Output, Failure>,
        subscribeImmediately: Bool = true
    ) {
        self.publisher = publisher
        if subscribeImmediately {
            startListening()
        }
    }
    
    func startListening() {
        if subscription != nil {
            return
        }
        subscription = publisher.sink { [weak self] completion in
            switch completion {
            case let .failure(error):
                self?.failureError = error
            case .finished:
                self?.didComplete = true
            }
        } receiveValue: { [weak self] value in
            self?.receivedValues.append(value)
        }
    }
    
    private(set) var receivedValues: [Output] = []
    private(set) var didComplete: Bool = false
    private(set) var failureError: Failure?
}
