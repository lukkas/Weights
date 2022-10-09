//
//  PlannerPageViewModel.swift
//  Core
//
//  Created by Łukasz Kasperek on 16/06/2022.
//

import Foundation

class PlannerPageViewModel: ObservableObject, Identifiable, Hashable {
    let id = UUID()
    var name: String
    @Published var exercises: [PlannerExerciseViewModel]
    
    init(name: String, exercises: [PlannerExerciseViewModel] = []) {
        self.name = name
        self.exercises = exercises
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(exercises)
    }
    
    static func == (
        lhs: PlannerPageViewModel,
        rhs: PlannerPageViewModel
    ) -> Bool {
        return lhs.id == rhs.id
        && lhs.name == rhs.name
        && lhs.exercises == rhs.exercises
    }
}
