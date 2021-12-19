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
extension ExerciseCellViewModel {
    static func make(count: Int = 1) -> [ExerciseCellViewModel] {
        let names = [
            "Squat", "Bench press", "Deadlift", "Sumo deadlift", "Seal row",
            "Biecep curl", "Tricep extension", "Farmer walk"
        ]
        return (0 ..< count).map { index in
            let name = names[index % names.count]
            return ExerciseCellViewModel(id: UUID(), exerciseName: name)
        }
    }
}
#endif
