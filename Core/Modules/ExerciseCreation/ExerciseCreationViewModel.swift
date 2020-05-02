//
//  ExerciseCreationViewModel.swift
//  Core
//
//  Created by Łukasz Kasperek on 11/04/2020.
//  Copyright © 2020 Łukasz Kasperek. All rights reserved.
//

import Foundation
import SwiftUI

class ExerciseCreationViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var metric: BiSelector.Model
    @Published var laterality: GraphicalSelector.Model
    
    init() {
        metric = BiSelector.Model(
            options: [
                L10n.ExerciseCreation.MetricSelector.reps,
                L10n.ExerciseCreation.MetricSelector.duration
            ],
            selectedIndex: 0
        )
        laterality = .init(
            options: [
                .init(
                    image: Image(systemName: "tray.fill"),
                    description: L10n.ExerciseCreation.LateralitySelector.bilateral
                ),
                .init(
                    image: Image(systemName: "folder.fill"),
                    description: L10n.ExerciseCreation.LateralitySelector.unilateralSimultaneous
                ),
                .init(
                    image: Image(systemName: "paperplane.fill"),
                    description: L10n.ExerciseCreation.LateralitySelector.unilateralSeparate
                )
            ],
            selectedIndex: 0
        )
    }
}
