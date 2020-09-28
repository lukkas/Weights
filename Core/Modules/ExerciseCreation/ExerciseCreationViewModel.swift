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
    var isProcessing: Bool { get }
    var didAddExercise: AnyPublisher<Void, Never> { get }
    
    func handleAddTapped()
}

class ExerciseCreationViewModel: ExerciseCreationViewModeling {
    @Published var name: String  = ""
    @Published var metric: Exercise.Metric?
    @Published var laterality: Exercise.Laterality?
    @Published var isAddButtonActive = false
    @Published private(set) var isProcessing: Bool = false
    var didAddExercise: AnyPublisher<Void, Never> {
        didAddExerciseSubject.eraseToAnyPublisher()
    }
    private var didAddExerciseSubject = PassthroughSubject<Void, Never>()
    
    private let exerciseStorage: ExerciseStoring
    
    init(exerciseStorage: ExerciseStoring) {
        self.exerciseStorage = exerciseStorage
        configureSwitchingAddButtonActive()
    }
    
    private func configureSwitchingAddButtonActive() {
        $name
            .combineLatest($metric, $laterality) { name, laterality, metric in
                return name.isValidName
                    && laterality != nil
                    && metric != nil
            }
            .assign(to: &$isAddButtonActive)
    }
    
    func handleAddTapped() {
        guard name.isValidName else { return }
        guard
            let metric = self.metric,
            let laterality = self.laterality else {
            return
        }
        let exercise = Exercise(
            id: UUID(),
            name: name,
            metric: metric,
            laterality: laterality
        )
        exerciseStorage.insert(exercise)
        didAddExerciseSubject.send(Void())
    }
}

private extension String {
    var isValidName: Bool { count > 1 }
}
