//
//  PlannerExerciseViewModel.swift
//  PlannerExerciseViewModel
//
//  Created by Łukasz Kasperek on 14/08/2021.
//  Copyright © 2021 Łukasz Kasperek. All rights reserved.
//

import Foundation

//class PlannerExerciseViewModel: PlannerExerciseViewModeling {
//    let name: String
//    @Published var adder = PlannerSetCellModel()
//    @Published var variations: [PlannerSetCellModel] = []
//    
//    init(name: String) {
//        self.name = name
//    }
//}

class AggregatePlannerSetCellModel: AggregatePlannerSetCellModeling, Identifiable {
    @Published private(set) var numberOfSets: Int
    @Published private(set) var reps: Double
    @Published private(set) var weight: Double
    
    init(reps: Double, weight: Double) {
        self.reps = reps
        self.weight = weight
        self.numberOfSets = 1
    }
    
    func handleRemoveSetTapped() {
        
    }
}
