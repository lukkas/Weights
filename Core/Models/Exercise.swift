//
//  Exercise.swift
//  Core
//
//  Created by Łukasz Kasperek on 03/05/2020.
//  Copyright © 2020 Łukasz Kasperek. All rights reserved.
//

import Foundation

public struct Exercise: Equatable, Codable {
    public enum Metric: CaseIterable, Codable {
        case reps, duration, distance
    }
    
    public enum Laterality: CaseIterable, Codable {
        case bilateral, unilateralSingle, unilateralIndividual
    }
    
    public let id: UUID
    public let name: String
    public let metric: Metric
    public let laterality: Laterality
    
    public init(
        id: UUID,
        name: String,
        metric: Exercise.Metric,
        laterality: Exercise.Laterality
    ) {
        self.id = id
        self.name = name
        self.metric = metric
        self.laterality = laterality
    }
}

extension Exercise.Metric: Identifiable {
    public var id: Self {
        return self
    }
}

extension Exercise.Laterality: Identifiable {
    public var id: Self {
        return self
    }
}

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

extension Exercise: Buildable {
    typealias BuilderType = ExerciseBuilder
}

struct ExerciseBuilder: Builder {
    private var name: String = "Squat"
    private var metric: Exercise.Metric = .reps
    private var laterality: Exercise.Laterality = .bilateral
    
    func build() -> Exercise {
        return Exercise(
            id: UUID(),
            name: name,
            metric: metric,
            laterality: laterality
        )
    }
    
    func withName(_ name: String) -> ExerciseBuilder {
        var copy = self
        copy.name = name
        return copy
    }
}

//extension Exercise {
//    static var dummy: Exercise {
//        return .init(
//            id: .init(),
//            name: "Squat",
//            metric: .reps,
//            laterality: .bilateral
//        )
//    }
//    
//    static func make() -> Exercise {
//        return make(count: 1).first!
//    }
//    
//    static func make(count: Int) -> [Exercise] {
//        let names = [
//            "Squat", "Bench press", "Deadlift", "Sumo deadlift", "Seal row",
//            "Biecep curl", "Tricep extension", "Farmer walk"
//        ]
//        guard count <= names.count else {
//            preconditionFailure("too little exercises. Do sth!")
//        }
//        return names.prefix(count).map { name in
//            Exercise(
//                id: UUID(),
//                name: name,
//                metric: .reps,
//                laterality: .bilateral
//            )
//        }
//    }
//}
#endif
