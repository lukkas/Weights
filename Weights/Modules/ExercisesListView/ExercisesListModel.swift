//
//  ExercisesListModel.swift
//  Weights
//
//  Created by Łukasz Kasperek on 14/07/2019.
//  Copyright © 2019 Łukasz Kasperek. All rights reserved.
//

import Foundation

struct ExercisesListModel {
    let exercises: [ExerciseCellModel]
}

#if DEBUG
extension ExercisesListModel {
    static var sample: ExercisesListModel {
        return ExercisesListModel(exercises: [
            .sample,
            .sample,
            .sample
        ])
    }
}
#endif
