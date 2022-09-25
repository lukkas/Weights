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
    @Binding var isPresented: Bool
    
    init(isPresented: Binding<Bool>) {
        _isPresented = isPresented
    }
}
