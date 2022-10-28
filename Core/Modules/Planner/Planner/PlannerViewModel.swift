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

class PlannerViewModel: ObservableObject {
    @Published var pages: [PlannerPageViewModel] = []
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
    @Binding var isPresented: Bool
    
    private let interactor: PlannerInteracting
    
    init(
        interactor: PlannerInteracting,
        isPresented: Binding<Bool>
    ) {
        self.interactor = interactor
        _isPresented = isPresented
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
}
