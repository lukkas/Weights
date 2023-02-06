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
    private typealias Alteration = (T.StubberType) -> T.StubberType
    enum IndexSet: Hashable, ExpressibleByIntegerLiteral {
        case all
        case equal(Int)
        case otherThan(Int)
        
        func doesApply(for index: Int) -> Bool {
            switch self {
            case .all: return true
            case let .equal(setIndex): return setIndex == index
            case let .otherThan(setIndex): return setIndex != index
            }
        }
        
        init(integerLiteral value: Int) {
            self = .equal(value)
        }
    }
    
    private var alterations: [IndexSet: [Alteration]] = [:]
    
    func setting<Value>(_ keyPath: WritableKeyPath<T.StubberType, Value>, to value: Value, atIndices indexSets: IndexSet...) -> Self {
        var copy = self
        for indexSet in indexSets {
            var alterations = copy.alterations[indexSet] ?? []
            alterations.append { $0.setting(keyPath, to: value) }
            copy.alterations[indexSet] = alterations
        }
        return copy
    }
    
    func stub(count: Int) -> [T] {
        var result = [T]()
        for index in 0 ..< count {
            let applicableAlterations = alterations
                .filter({ $0.key.doesApply(for: index) })
                .values
                .flatMap({ $0 })
            var builder = T.stubber()
            for alteration in applicableAlterations {
                builder = alteration(builder)
            }
            result.append(builder.stub())
        }
        return result
    }
}
#endif
