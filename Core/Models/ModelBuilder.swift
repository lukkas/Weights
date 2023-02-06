//
//  ModelBuilder.swift
//  Core
//
//  Created by Łukasz Kasperek on 22/10/2022.
//

import Foundation

#if DEBUG
protocol Buildable {
    associatedtype BuilderType: Builder where BuilderType.BuildableType == Self
    static func builder() -> BuilderType
    static func arrayBuilder() -> ArrayBuilder<Self>
}

extension Buildable {
    static func builder() -> BuilderType {
        return BuilderType()
    }
    
    static func arrayBuilder() -> ArrayBuilder<Self> {
        return ArrayBuilder()
    }
}

protocol Builder {
    associatedtype BuildableType: Buildable
    init()
    func build() -> BuildableType
}

extension Builder {
    func setting<T>(
        _ keyPath: WritableKeyPath<Self, T>,
        to value: T
    ) -> Self {
        var copy = self
        copy[keyPath: keyPath] = value
        return copy
    }
}

struct ArrayBuilder<T: Buildable> {
    typealias Tweak = (T.BuilderType) -> T.BuilderType
    enum Rule: Hashable, ExpressibleByIntegerLiteral {
        case index(Int)
        case indexOtherThan(Int)
        
        func doesApply(for index: Int) -> Bool {
            switch self {
            case let .index(ruleIndex): return ruleIndex == index
            case let .indexOtherThan(ruleIndex): return ruleIndex != index
            }
        }
        
        init(integerLiteral value: Int) {
            self = .index(value)
        }
    }
    
    private var tweaks: [Rule: [Tweak]] = [:]
    
    func with(_ tweak: @escaping Tweak, at rules: Rule...) -> Self {
        var copy = self
        for rule in rules {
            var tweaks = copy.tweaks[rule] ?? []
            tweaks.append(tweak)
            copy.tweaks[rule] = tweaks
        }
        return copy
    }
    
    func build(count: Int) -> [T] {
        var result = [T]()
        for index in 0 ..< count {
            let applicableTweaks = tweaks
                .filter({ $0.key.doesApply(for: index) })
                .values
                .flatMap({ $0 })
            var builder = T.builder()
            for tweak in applicableTweaks {
                builder = tweak(builder)
            }
            result.append(builder.build())
        }
        return result
    }
}
#endif
