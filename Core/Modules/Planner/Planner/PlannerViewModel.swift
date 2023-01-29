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
        case .save:
            saveAction()
        case .addPage:
            addPageAction()
        case .addExercise:
            addExerciseAction()
        case let .addSet(exercise, page):
            addSetAction(exercise: exercise, page: page)
        case let .removeSet(set, exercise, page):
            removeSetAction(set: set, exercise: exercise, page: page)
        case let .pageChanged(pageIndex):
            currentPageIndex = pageIndex
        case let .toggleSuperset(exercise, page):
            break
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
            exerciseId: exercise.id,
            name: exercise.name,
            pace: UIPacePicker.InputState(),
            sets: [defaultSet(for: exercise)],
            supersetIndex: nil
        )
    }
    
    private func defaultSet(for exercise: Exercise) -> PlannerExercise.Set {
        let config = PlannerExercise.Set.Config(
            metricLabel: exercise.metric.label,
            metricFieldMode: exercise.metric.parameterFieldMode,
            weightLabel: L10n.Common.kg
        )
        return PlannerExercise.Set(
            id: UUID(),
            weight: 0,
            repCount: 0,
            config: config
        )
    }
    
    private func addSetAction(
        exercise: PlannerExercise,
        page: PlannerPage
    ) {
        guard let exerciseModel = addedExercises[exercise.exerciseId] else {
            fatalError("didn't find exercise")
        }
        let toAdd = defaultSet(for: exerciseModel)
        mutateExercise(exercise, at: page) { exercise in
            exercise.sets.append(toAdd)
        }
    }
    
    private func removeSetAction(
        set: PlannerExercise.Set,
        exercise: PlannerExercise,
        page: PlannerPage
    ) {
        guard let setIndex = exercise.sets.firstIndex(of: set) else { return }
        mutateExercise(exercise, at: page) { exercise in
            exercise.sets.remove(at: setIndex)
        }
    }
    
    private func mutateExercise(
        _ exercise: PlannerExercise,
        at page: PlannerPage,
        mutation: (inout PlannerExercise) -> Void
    ) {
        guard
            let pageIndex = pages.firstIndex(of: page),
            let exerciseIndex = page.exercises.firstIndex(of: exercise) else {
            fatalError("didn't find exercise")
        }
        mutation(&pages[pageIndex].exercises[exerciseIndex])
    }
    
    private func saveAction() {
        let plan = createPlanFromViewModels()
        planStorage.insert(plan)
        planSavedSubject.send()
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

    private func extractExercises(from page: PlannerPage) -> [PlannedExercise] {
        return page.exercises.map { exercise in
            return PlannedExercise(
                exercise: addedExercises[exercise.exerciseId]!,
                setCollections: [],
                createsSupersets: false
            )
        }
    }
}
