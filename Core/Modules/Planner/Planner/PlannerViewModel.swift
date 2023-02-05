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
            toggleSuprset(after: exercise, onPage: page)
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
        mutateExercise(at: indexPath(of: exercise, onPage: page)) { exercise in
            exercise.sets.append(toAdd)
        }
    }
    
    private func removeSetAction(
        set: PlannerExercise.Set,
        exercise: PlannerExercise,
        page: PlannerPage
    ) {
        guard let setIndex = exercise.sets.firstIndex(of: set) else { return }
        mutateExercise(at: indexPath(of: exercise, onPage: page)) { exercise in
            exercise.sets.remove(at: setIndex)
        }
    }
    
    private func toggleSuprset(after exercise: PlannerExercise, onPage page: PlannerPage) {
        let ip = indexPath(of: exercise, onPage: page)
        let nextIp = next(from: ip)!
        let nextExercise = self.exercise(at: nextIp)
        switch (exercise.supersetIndex, nextExercise.supersetIndex) {
        case (nil, nil):
            let index = findFirstFreeSupersetIndex(onPage: ip.page)
            mutateExercise(at: ip) { exercise in
                exercise.supersetIndex = index
            }
            mutateExercise(at: nextIp) { exercise in
                exercise.supersetIndex = index
            }
        case (nil, _?):
            mutateExercise(at: ip) { mutated in
                mutated.supersetIndex = nextExercise.supersetIndex
            }
        case (_?, nil):
            mutateExercise(at: nextIp) { mutated in
                mutated.supersetIndex = exercise.supersetIndex
            }
        case let (one?, two?) where one == two:
            let oneIsPartOfOtherSuperset: Bool = {
                guard let previousIp = previous(from: ip) else { return false }
                return self.exercise(at: previousIp).supersetIndex == one
            }()
            let twoIsPartOfOtherSuperset: Bool = {
                guard let afterNextIp = next(from: nextIp) else { return false }
                return self.exercise(at: afterNextIp).supersetIndex == two
            }()
            switch (oneIsPartOfOtherSuperset, twoIsPartOfOtherSuperset) {
            case (false, false):
                mutateExercise(at: ip) { mutated in
                    mutated.supersetIndex = nil
                }
                mutateExercise(at: nextIp) { mutated in
                    mutated.supersetIndex = nil
                }
            case (true, false):
                mutateExercise(at: nextIp) { mutated in
                    mutated.supersetIndex = nil
                }
            case (false, true):
                mutateExercise(at: ip) { mutated in
                    mutated.supersetIndex = nil
                }
            case (true, true):
                let supersetIndex = findFirstFreeSupersetIndex(onPage: ip.page)
                mutatePageExercises(from: nextIp) { mutated in
                    if mutated.supersetIndex == one {
                        mutated.supersetIndex = supersetIndex
                    }
                }
            }
        case let (one?, two?) where one != two:
            mutatePageExercises(from: nextIp) { mutated in
                if mutated.supersetIndex == two {
                    mutated.supersetIndex = one
                }
            }
        default:
            fatalError("all cases should be handled, but compiler chan't check this one")
        }
    }
    
    private func findFirstFreeSupersetIndex(onPage pageIndex: Int) -> Int {
        let page = pages[pageIndex]
        var availableIndices = IndexSet(integersIn: 0...)
        for case let supersetIndex in page.exercises.compactMap(\.supersetIndex){
            if availableIndices.contains(supersetIndex) {
                availableIndices.remove(supersetIndex)
            }
        }
        return availableIndices.first!
    }
    
    private func mutateExercise(
        at indexPath: IndexPath,
        mutation: (inout PlannerExercise) -> Void
    ) {
        mutation(&pages[indexPath.page].exercises[indexPath.exercise])
    }
    
    private func indexPath(of exercise: PlannerExercise, onPage page: PlannerPage) -> IndexPath {
        guard
            let pageIndex = pages.firstIndex(of: page),
            let exerciseIndex = page.exercises.firstIndex(of: exercise) else {
            fatalError("didn't find exercise")
        }
        return IndexPath(page: pageIndex, exercise: exerciseIndex)
    }
    
    private func mutatePageExercises(
        from indexPath: IndexPath,
        mutation: (inout PlannerExercise) -> Void
    ) {
        for exerciseIndex in indexPath.exercise ..< pages[indexPath.page].exercises.count {
            mutation(&pages[indexPath.page].exercises[exerciseIndex])
        }
    }
    
    private func exercise(at indexPath: IndexPath) -> PlannerExercise {
        pages[indexPath.page].exercises[indexPath.exercise]
    }
    
    private func next(from indexPath: IndexPath) -> IndexPath? {
        let nextCandidate = indexPath.exercise + 1
        return pages[indexPath.page].exercises.count > nextCandidate
            ? IndexPath(page: indexPath.page, exercise: nextCandidate)
            : nil
    }
    
    private func previous(from indexPath: IndexPath) -> IndexPath? {
        let nextCandidate = indexPath.exercise - 1
        return nextCandidate >= 0
            ? IndexPath(page: indexPath.page, exercise: nextCandidate)
            : nil
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

private extension IndexPath {
    init(page: Int, exercise: Int) {
        self.init(item: exercise, section: page)
    }
    
    var page: Int { section }
    var exercise: Int { item }
}
