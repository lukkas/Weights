//
//  ExercisePickerViewModel.swift
//  Core
//
//  Created by Łukasz Kasperek on 21/11/2021.
//  Copyright © 2021 Łukasz Kasperek. All rights reserved.
//

import Combine
import Foundation
import SwiftUI

class ExercisePickerViewModel: ExercisePickerViewModeling {
    @Published private(set) var exercises: [ExerciseCellViewModel] = []
    @Published private(set) var pickedExercises: [ExerciseCellViewModel] = []
    @Published private(set) var addButtonDisabled: Bool = true
    var searchText: String = "" {
        didSet {
            applyCellViewModels()
        }
    }
    private var pickedIds: [UUID] = []
    private var exerciseModels = [Exercise]()
    
    private let exerciseStorage: ExerciseStoring
    private let pickedRelay: ExercisePickerRelay
    private var cancellables: Set<AnyCancellable> = []
    
    init(
        exerciseStorage: ExerciseStoring,
        pickedRelay: ExercisePickerRelay
    ) {
        self.exerciseStorage = exerciseStorage
        self.pickedRelay = pickedRelay
        subscribeToExercisesUpdates()
    }
    
    private func subscribeToExercisesUpdates() {
        exerciseStorage.exercises()
            .sink { [weak self] exercises in
                self?.exerciseModels = exercises
                self?.applyCellViewModels()
            }
            .store(in: &cancellables)
    }
    
    func handleViewAppeared() {
        
    }
    
    func pick(_ exercise: ExerciseCellViewModel) {
        pickedIds.append(exercise.id)
        applyCellViewModels()
        updateAddButtonDisabledState()
    }
    
    func remove(_ exercise: ExerciseCellViewModel) {
        pickedIds.removeAll(where: { $0 == exercise.id })
        applyCellViewModels()
        updateAddButtonDisabledState()
    }
    
    private func applyCellViewModels() {
        let mapping: (Exercise) -> ExerciseCellViewModel = { exercise in
            ExerciseCellViewModel(
                id: exercise.id,
                exerciseName: exercise.name
            )
        }
        let searchFiltering: (Exercise) -> Bool = { [searchText] exercise in
            if searchText.isEmpty { return true }
            return exercise.name.localizedCaseInsensitiveContains(searchText)
        }
        exercises = exerciseModels
            .filter(searchFiltering)
            .filter({ !pickedIds.contains($0.id) })
            .map(mapping)
        pickedExercises = pickedExerciseModels
            .map(mapping)
    }
    
    private var pickedExerciseModels: [Exercise] {
        return pickedIds
            .map({ id in
                exerciseModels.first(where: { $0.id == id })!
            })
    }
    
    private func updateAddButtonDisabledState() {
        addButtonDisabled = pickedIds.isEmpty
    }
    
    func handleAddTapped() {
        assert(!pickedIds.isEmpty, "add button should be disabled when empty")
        pickedRelay.pick(pickedExerciseModels)
    }
    
    func handleCancelTapped() {
        pickedRelay.pick([])
    }
}
