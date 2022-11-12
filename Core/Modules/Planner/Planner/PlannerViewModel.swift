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

enum PlannerAction {
    case save
    case pageChanged(Int)
    case addPage
    case addExercise
}

class PlannerViewModel: PlannerViewModeling {
    @Published var pages: [PlannerPage] = []
    @Published var exercisePickerRelay: ExercisePickerRelay?
    var planSaved: AnyPublisher<Void, Never> { planSavedSubject.eraseToAnyPublisher() }
    private let planSavedSubject = PassthroughSubject<Void, Never>()
    
    private var currentPageIndex: Int = 0
    private var addedExercises = [UUID: Exercise]()
    
    private let planStorage: PlanStoring
    
    init(planStorage: PlanStoring) {
        self.planStorage = planStorage
        pages = [makeTemplatePage()]
    }
    
    private func makeTemplatePage() -> PlannerPage {
        return PlannerPage(
            id: UUID(),
            name: "A1",
            exercises: []
        )
    }
    
    func consume(_ action: PlannerAction) {
        switch action {
        case .save: break
        case .addPage: addPageAction()
        case .addExercise: addExerciseAction()
        case let .pageChanged(pageIndex):
            currentPageIndex = pageIndex
        }
    }
    
    private func addPageAction() {
        pages.append(makeTemplatePage())
    }
    
    private func addExerciseAction() {
        exercisePickerRelay = ExercisePickerRelay(onPicked: { [weak self] exercises in
            self?.handleExercisesPicked(exercises)
            self?.exercisePickerRelay = nil
        })
    }
    
    private func handleExercisesPicked(_ exercises: [Exercise])  {
        exercises.forEach { exercise in
            addedExercises[exercise.id] = exercise
        }
        let exerciseModels = exercises.map(plannerExercise(for:))
        pages[currentPageIndex].exercises.append(contentsOf: exerciseModels)
    }
    
    private func plannerExercise(for exercise: Exercise) -> PlannerExercise {
        return PlannerExercise(
            id: UUID(),
            name: exercise.name,
            pace: UIPacePicker.InputState(),
            sets: defaultSets(for: exercise),
            createsSupersets: false
        )
    }
    
    private func defaultSets(for exercise: Exercise) -> [PlannerExercise.Set] {
        let config = PlannerExercise.Set.Config(
            metricLabel: exercise.metric.label,
            metricFieldMode: exercise.metric.parameterFieldMode,
            weightLabel: L10n.Common.kg
        )
        let set = PlannerExercise.Set(
            id: UUID(),
            weight: 0,
            repCount: 0,
            config: config
        )
        return [set]
    }
    
    private func saveCreatedPlan() {
//        let plan = createPlanFromViewModels()
    }
    
//    private func createPlanFromViewModels() -> Plan {
//        return Plan(
//            id: UUID(),
//            name: "Can't name plan yet",
//            days: collectPlannedDays(),
//            isCurrent: false
//        )
//    }
//
//    private func collectPlannedDays() -> [PlannedDay] {
//        return pages.map { pageViewModel in
//            return PlannedDay(
//                name: pageViewModel.name,
//                exercises: extractExercises(from: pageViewModel)
//            )
//        }
//    }
//
//    private func extractExercises(from page: Page) -> [PlannedExercise] {
//        return page.exercises.flatMap { exerciseViewModel in
//            return exerciseViewModel.headerRows.map { headerRow in
//                return PlannedExercise(
//                    exercise: addedExercises[headerRow.exerciseId]!,
//                    setCollections: [],
//                    createsSupersets: false
//                )
//            }
//        }
//    }
}
