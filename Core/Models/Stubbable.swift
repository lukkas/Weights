//
//  ModelBuilder.swift
//  Core
//
//  Created by Łukasz Kasperek on 22/10/2022.
//

import Foundation

#if DEBUG
protocol Stubbable {
    associatedtype StubberType: Stubber where StubberType.StubbableType == Self
    static func stubber() -> StubberType
    static func arrayStubber() -> ArrayStubber<Self>
}

extension Stubbable {
    static func stubber() -> StubberType {
        return StubberType()
    }
    
    static func arrayStubber() -> ArrayStubber<Self> {
        return ArrayStubber()
    }
}

protocol Stubber {
    associatedtype StubbableType: Stubbable
    init()
    func stub() -> StubbableType
}

extension Stubber {
    func setting<T>(
        _ keyPath: WritableKeyPath<Self, T>,
        to value: T
    ) -> Self {
        var copy = self
        copy[keyPath: keyPath] = value
        return copy
    }
}

struct ArrayStubber<T: Stubbable> {
    typealias Tweak = (T.StubberType) -> T.StubberType
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
    
    func stub(count: Int) -> [T] {
        var result = [T]()
        for index in 0 ..< count {
            let applicableTweaks = tweaks
                .filter({ $0.key.doesApply(for: index) })
                .values
                .flatMap({ $0 })
            var builder = T.stubber()
            for tweak in applicableTweaks {
                builder = tweak(builder)
            }
            result.append(builder.stub())
        }
        return result
    }
}
#endif
