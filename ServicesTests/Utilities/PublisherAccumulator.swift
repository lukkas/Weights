//
//  PublisherAccumulator.swift
//  ServicesTests
//
//  Created by Łukasz Kasperek on 30/01/2022.
//

import Combine
import Foundation

class PublisherAccumulator<Value, Failure: Error> {
    private(set) var isCompleted: Bool = false
    private(set) var publisherFailure: Error?
    private(set) var updates: [Value] = []
    
    private var cancellable: AnyCancellable?
    
    init(publisher: AnyPublisher<Value, Failure>) {
        cancellable = publisher.sink { [weak self] completion in
            if case let .failure(error) = completion {
                self?.publisherFailure = error
            }
            self?.isCompleted = true
        } receiveValue: { [weak self] value in
            self?.updates.append(value)
        }
    }
    
    func update(at index: Int) -> Value? {
        guard updates.count > index else { return nil }
        return updates[index]
    }
}
