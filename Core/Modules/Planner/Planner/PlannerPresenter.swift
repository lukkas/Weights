//
//  PlannerPresenter.swift
//  Core
//
//  Created by Łukasz Kasperek on 24/09/2022.
//

import Foundation

class PlannerPresenter: PlannerPresenting {
    private var addedExercises = [UUID: Exercise]()
    
    private let viewModel: PlannerViewModel
    private let planStorage: PlanStoring
    
    init(viewModel: PlannerViewModel, planStorage: PlanStoring) {
        self.viewModel = viewModel
        self.planStorage = planStorage
        viewModel.pages = [makeTemplateUnitModel()]
    }
    
    private func makeTemplateUnitModel() -> PlannerPageViewModel {
        return PlannerPageViewModel(name: "A1")
    }
    
    func cancelNavigationButtonTapped() {
        viewModel.isPresented = false
    }
    
    func saveNavigationButtonTapped() {
        saveCreatedPlan()
        viewModel.isPresented = false
    }
    
    private func saveCreatedPlan() {
        let plan = createPlanFromViewModels()
        planStorage.insert(plan)
    }
    
    private func createPlanFromViewModels() -> Plan {
        return Plan(
            id: UUID(),
            name: "Can't name plan yet",
            days: collectPlannedDays(),
            isCurrent: false
        )
    }
    
    private func collectPlannedDays() -> [PlannedDay] {
        return viewModel.pages.map { pageViewModel in
            return PlannedDay(
                name: pageViewModel.name,
                exercises: extractExercises(from: pageViewModel)
            )
        }
    }
    
    private func extractExercises(
        from pageViewModel: PlannerPageViewModel
    ) -> [PlannedExercise] {
        return pageViewModel.exercises.flatMap { exerciseViewModel in
            return exerciseViewModel.headerRows.map { headerRow in
                return PlannedExercise(
                    exercise: addedExercises[headerRow.exerciseId]!,
                    setCollections: [],
                    createsSupersets: false
                )
            }
        }
    }
    
    func plusTapped() {
        viewModel.pages.append(makeTemplateUnitModel())
        viewModel.visiblePage = viewModel.pages.indices.last!
    }
    
    func leftArrowTapped() {
        if viewModel.leftArrowDisabled { return }
        viewModel.visiblePage -= 1
    }
    
    func rightArrowTapped() {
        if viewModel.rightArrowDisabled { return }
        viewModel.visiblePage += 1
    }
    
    func addExerciseTapped() {
        viewModel.exercisePickerRelay = ExercisePickerRelay(onPicked: { [weak self] exercises in
            self?.handleExercisesPicked(exercises)
            self?.viewModel.exercisePickerRelay = nil
        })
    }
    
    private func handleExercisesPicked(_ exercises: [Exercise])  {
        exercises.forEach { exercise in
            addedExercises[exercise.id] = exercise
        }
        let exerciseModels = exercises.map(createExerciseViewModel(for:))
        visiblePage.exercises.append(contentsOf: exerciseModels)
    }
    
    private var visiblePage: PlannerPageViewModel {
        return viewModel.pages[viewModel.visiblePage]
    }
    
    private func createExerciseViewModel(for exercise: Exercise) -> PlannerExerciseViewModel {
        weak var weakModel: PlannerExerciseViewModel!
        let model = PlannerExerciseViewModel(
            headerRows: [PlannerExerciseHeaderRow(exerciseId: exercise.id, name: exercise.name)],
            variations: [defaultExerciseSetVariation(for: exercise)],
            onAddVarationTap: { [weak self] in
                guard let self else { return }
                let newSetVariation = self.defaultExerciseSetVariation(for: exercise)
                weakModel.variations.append(newSetVariation)
            },
            onSupersetAction: { action in
                switch action {
                case .add: self.handleAddSupersetAction(on: weakModel)
                case .remove: break
                }
            },
            onVariationsChanged: { variations in
                if let index = variations.lastIndex(where: { $0.numberOfSets == 0 }) {
                    weakModel.variations.remove(at: index)
                }
            }
        )
        weakModel = model
        return model
    }
    
    private func handleAddSupersetAction(on exerciseVM: PlannerExerciseViewModel) {
        guard
            let index = visiblePage.exercises.firstIndex(of: exerciseVM),
            visiblePage.exercises.indices.contains(index + 1) else { return }
        
    }
    
    private func defaultExerciseSetVariation(for exercise: Exercise) -> PlannerSetsCellModel {
        let exerciseSet = PlannerSetsCellModel.ExerciseSet(
            metricLabel: exercise.metric.label,
            metricFieldMode: exercise.metric.parameterFieldMode,
            weightLabel: L10n.Common.kg
        )
        return PlannerSetsCellModel(
            numberOfSets: 1,
            exerciseSets: [exerciseSet]
        )
    }
}
