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
    var metric: Exercise.Metric? { get set }
    var laterality: Exercise.Laterality? { get set }
    var isAddButtonActive: Bool { get set }
}

class ExerciseCreationViewModel: ExerciseCreationViewModeling {
    @Published var name: String  = ""
    @Published var metric: Exercise.Metric?
    @Published var laterality: Exercise.Laterality?
    @Published var isAddButtonActive = false
    
    private let exerciseStorage: ExerciseStoring
    
    init(exerciseStorage: ExerciseStoring) {
        self.exerciseStorage = exerciseStorage
        configureSwitchingAddButtonActive()
    }
    
    private func configureSwitchingAddButtonActive() {
        $name
            .combineLatest($metric, $laterality) { name, laterality, metric in
                return name.count > 1 && laterality != nil && metric != nil
            }
            .assign(to: &$isAddButtonActive)
    }
    
    func handleDoneTapped() {
        
    }
}
