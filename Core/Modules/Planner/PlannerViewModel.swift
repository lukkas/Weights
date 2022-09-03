//
//  PlannerViewModel.swift
//  Core
//
//  Created by Łukasz Kasperek on 04/10/2020.
//  Copyright © 2020 Łukasz Kasperek. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

struct ExercisePickerRelay: Identifiable {
    let id = UUID()
    private let onPicked: ([Exercise]) -> Void
    
    init(onPicked: @escaping ([Exercise]) -> Void) {
        self.onPicked = onPicked
    }
    
    func pick(_ exercises: [Exercise]) {
        onPicked(exercises)
    }
}

class PlannerViewModel: PlannerViewModeling {
    typealias ExerciseViewModel = PlannerExerciseViewModel
    
    @Published var pages: [PlannerPageViewModel<PlannerExerciseViewModel>] = []
    @Published var visiblePage: Int = 0
    var leftArrowDisabled: Bool {
        return visiblePage == 0
    }
    var rightArrowDisabled: Bool {
        return visiblePage == pages.indices.last
    }
    var currentUnitName: String {
        get {
            pages[visiblePage].name
        }
        set {
            objectWillChange.send()
            pages[visiblePage].name = newValue
        }
    }
    @Published var exercisePickerRelay: ExercisePickerRelay?
    @Binding private var isPresented: Bool
    private let planStorage: PlanStoring
    
    init(isPresented: Binding<Bool>, planStorage: PlanStoring) {
        _isPresented = isPresented
        self.planStorage = planStorage
        pages = [makeTemplateUnitModel()]
    }
    
    private func makeTemplateUnitModel() -> PlannerPageViewModel<PlannerExerciseViewModel> {
        return PlannerPageViewModel(name: "A1")
    }
    
    func cancelNavigationButtonTapped() {
        isPresented = false
    }
    
    func saveNavigationButtonTapped() {
        saveCreatedPlan()
        isPresented = false
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
        return pages.map { pageViewModel in
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
    
    func addExerciseTapped() {
        exercisePickerRelay = ExercisePickerRelay(onPicked: { [weak self] exercises in
            self?.handleExercisesPicked(exercises)
            self?.exercisePickerRelay = nil
        })
    }
    
    private func handleExercisesPicked(_ exercises: [Exercise])  {
        let unit = pages[visiblePage]
        let exerciseModels = exercises.map {
            PlannerExerciseViewModel(exercise: $0)
        }
        unit.addExercises(exerciseModels)
    }
    
    func leftArrowTapped() {
        if leftArrowDisabled { return }
        visiblePage -= 1
    }
    
    func rightArrowTapped() {
        if rightArrowDisabled { return }
        visiblePage += 1
    }
    
    func plusTapped() {
        pages.append(makeTemplateUnitModel())
        visiblePage = pages.indices.last!
    }
}
