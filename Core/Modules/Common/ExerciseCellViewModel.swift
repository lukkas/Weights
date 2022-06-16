//
//  ExerciseCellViewModel.swift
//  Core
//
//  Created by Łukasz Kasperek on 28/09/2020.
//  Copyright © 2020 Łukasz Kasperek. All rights reserved.
//

import Foundation

struct ExerciseCellViewModel: Identifiable, Hashable {
    let id: UUID
    let exerciseName: String
}

// MARK: - Design time

#if DEBUG
extension Array where Element == ExerciseCellViewModel {
    static func make(count: Int = 1) -> [ExerciseCellViewModel] {
        return (0 ..< count).map { index in
            return .make(nameAt: index)
        }
    }
}
extension ExerciseCellViewModel {
    static func make(nameAt nameIndex: Int = 0) -> Self {
        let names = [
            "Squat", "Bench press", "Deadlift", "Sumo deadlift", "Seal row",
            "Biecep curl", "Tricep extension", "Farmer walk"
        ]
        let name = names[nameIndex % names.count]
        return ExerciseCellViewModel(id: UUID(), exerciseName: name)
    }
}
#endif
