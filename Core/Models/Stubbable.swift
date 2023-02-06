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
}

extension Stubbable {
    static func stubber() -> StubberType {
        return StubberType()
    }
    
    /// Convienience method, when no parameters need to be
    /// modified for the purpose of a test
    static func dummy() -> Self {
        return stubber().stub()
    }
}

extension Array where Element: Stubbable {
    static func stubber() -> ArrayStubber<Element> {
        return ArrayStubber()
    }
    
    /// Convenience method, when no parameters need to be
    /// modified for the purpose of a test
    /// - Parameter count: Number of elements to create
    /// - Returns: Dummies
    static func dummies(count: Int) -> [Element] {
        return stubber().stub(count: count)
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
    private typealias Tweak = (T.StubberType) -> T.StubberType
    enum IndexSet: Hashable, ExpressibleByIntegerLiteral {
        case equal(Int)
        case otherThan(Int)
        
        func doesApply(for index: Int) -> Bool {
            switch self {
            case let .equal(setIndex): return setIndex == index
            case let .otherThan(setIndex): return setIndex != index
            }
        }
        
        init(integerLiteral value: Int) {
            self = .equal(value)
        }
    }
    
    private var tweaks: [IndexSet: [Tweak]] = [:]
    
    func setting<Value>(_ keyPath: WritableKeyPath<T.StubberType, Value>, to value: Value, atIndices indexSets: IndexSet...) -> Self {
        var copy = self
        for indexSet in indexSets {
            var tweaks = copy.tweaks[indexSet] ?? []
            tweaks.append { $0.setting(keyPath, to: value) }
            copy.tweaks[indexSet] = tweaks
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
