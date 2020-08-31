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
}

class ExerciseCreationViewModel: ExerciseCreationViewModeling {
    @Published var name: String  = ""
    @Published var metric: Exercise.Metric?
    @Published var laterality: Exercise.Laterality?
    
    private let exerciseStorage: ExerciseStoring
    
    init(exerciseStorage: ExerciseStoring) {
        self.exerciseStorage = exerciseStorage
    }
    
    func handleDoneTapped() {
        
    }
}
