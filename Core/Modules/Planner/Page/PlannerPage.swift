//
//  PlannerPageViewModel.swift
//  Core
//
//  Created by Łukasz Kasperek on 16/06/2022.
//

import Foundation

struct PlannerPage: Identifiable, Hashable {
    let id: UUID
    var name: String
    var exercises: [PlannerExercise]
}
