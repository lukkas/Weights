//
//  PlannerPresenter.swift
//  Core
//
//  Created by Łukasz Kasperek on 24/09/2022.
//

import Foundation

class PlannerPresenter: PlannerPresenting {
    private let viewModel: PlannerViewModel
    private let planStorage: PlanStoring
    
    init(viewModel: PlannerViewModel, planStorage: PlanStoring) {
        self.viewModel = viewModel
        self.planStorage = planStorage
        viewModel.pages = [makeTemplateUnitModel()]
    }
    
    private func makeTemplateUnitModel() -> PlannerPageViewModel<PlannerExerciseViewModel> {
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
        from pageViewModel: PlannerPageViewModel<PlannerExerciseViewModel>
    ) -> [PlannedExercise] {
        return pageViewModel.exercises.map { exerciseViewModel in
            return PlannedExercise(
                exercise: exerciseViewModel.exercise,
                setCollections: [],
                createsSupersets: false
            )
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
        let unit = viewModel.pages[viewModel.visiblePage]
        let exerciseModels = exercises.map {
            PlannerExerciseViewModel(exercise: $0)
        }
        unit.addExercises(exerciseModels)
    }
}
