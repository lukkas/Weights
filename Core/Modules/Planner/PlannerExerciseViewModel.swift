//
//  PlannerExerciseViewModel.swift
//  Core
//
//  Created by Łukasz Kasperek on 07/11/2021.
//  Copyright © 2021 Łukasz Kasperek. All rights reserved.
//

import Foundation

class PlannerExerciseViewModel: PlannerExerciseViewModeling {
    var name: String { exercise.name }
    @Published var variations: [PlannerSetCellModel] = [] {
        didSet {
            performPostVariationsModificationCheck()
        }
    }
    
    private let exercise: Exercise
    
    init(exercise: Exercise) {
        self.exercise = exercise
        prepareInitialVariationsState()
    }
    
    required init(archive: PlannerExerciseViewModelArchive) {
        let container = archive.dataContainer
        self.exercise = container.exercise
        self.variations = container.cells
    }
    
    private func prepareInitialVariationsState() {
        variations = [baseVariation()]
    }
    
    private func baseVariation() -> PlannerSetCellModel {
        PlannerSetCellModel(
            metric: exercise.metric,
            numerOfSets: 1,
            metricValue: nil,
            weight: nil
        )
    }
    
    private func performPostVariationsModificationCheck() {
        if let index = variations.lastIndex(where: { $0.numerOfSets == 0 }) {
            variations.remove(at: index)
        }
    }
    
    func addVariationTapped() {
        variations.append(baseVariation())
    }
    
    func draggingArchive() -> PlannerExerciseViewModelArchive {
        return PlannerExerciseViewModelArchive(
            exercise: exercise,
            cells: variations
        )
    }
}
