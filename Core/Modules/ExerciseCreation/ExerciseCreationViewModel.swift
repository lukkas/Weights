//
//  ExerciseCreationViewModel.swift
//  Core
//
//  Created by Łukasz Kasperek on 11/04/2020.
//  Copyright © 2020 Łukasz Kasperek. All rights reserved.
//

import Combine
import Foundation
import SwiftUI

protocol ExerciseCreationViewModeling: ObservableObject {
    var name: String { get set }
    var volumeUnit: Exercise.VolumeUnit? { get set }
    var laterality: Exercise.Laterality? { get set }
}

class ExerciseCreationViewModel: ExerciseCreationViewModeling {
    @Published var name: String  = ""
    @Published var volumeUnit: Exercise.VolumeUnit?
    @Published var laterality: Exercise.Laterality?
    
    private let exerciseStorage: ExerciseStoring
    
    init(exerciseStorage: ExerciseStoring) {
        self.exerciseStorage = exerciseStorage
    }
    
    var metricTitles: [String] {
        [L10n.ExerciseCreation.MetricSelector.reps,
         L10n.ExerciseCreation.MetricSelector.duration]
    }
    
    var lateralityOptions: [GraphicalSelector.Option] {
        [
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
        ]
    }
    
    func handleDoneTapped() {
        
    }
}
