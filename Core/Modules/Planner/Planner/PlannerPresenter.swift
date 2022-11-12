//
//  PlannerPresenter.swift
//  Core
//
//  Created by Łukasz Kasperek on 24/09/2022.
//

import Foundation

class PlannerPresenter {
    private var addedExercises = [UUID: Exercise]()
    
    private let viewModel: PlannerViewModel
    private let planStorage: PlanStoring
    
    init(viewModel: PlannerViewModel, planStorage: PlanStoring) {
        self.viewModel = viewModel
        self.planStorage = planStorage
    }
    
//    private func createExerciseViewModel(for exercise: Exercise) -> PlannerExerciseViewModel {
//        weak var weakModel: PlannerExerciseViewModel!
//        let model = PlannerExerciseViewModel(
//            headerRows: [PlannerExerciseHeaderRow(exerciseId: exercise.id, name: exercise.name)],
//            variations: [defaultExerciseSetVariation(for: exercise)],
//            onAddVarationTap: { [weak self] in
//                guard let self else { return }
//                let newSetVariation = self.defaultExerciseSetVariation(for: exercise)
//                weakModel.variations.append(newSetVariation)
//            },
//            onSupersetAction: { action in
//                switch action {
//                case .add: self.handleAddSupersetAction(on: weakModel)
//                case .remove: break
//                }
//            },
//            onVariationsChanged: { variations in
//                if let index = variations.lastIndex(where: { $0.numberOfSets == 0 }) {
//                    weakModel.variations.remove(at: index)
//                }
//            }
//        )
//        weakModel = model
//        return model
//    }
    
//    private func handleAddSupersetAction(on exerciseVM: PlannerExerciseViewModel) {
//        guard
//            let index = visiblePage.exercises.firstIndex(of: exerciseVM),
//            visiblePage.exercises.indices.contains(index + 1) else { return }
//
//    }
    
//    private func defaultExerciseSetVariation(for exercise: Exercise) -> PlannerSetsCellModel {
//        let exerciseSet = PlannerSetsCellModel.ExerciseSet(
//            metricLabel: exercise.metric.label,
//            metricFieldMode: exercise.metric.parameterFieldMode,
//            weightLabel: L10n.Common.kg
//        )
//        return PlannerSetsCellModel(
//            numberOfSets: 1,
//            exerciseSets: [exerciseSet]
//        )
//    }
}
