//
//  CoreEntry.swift
//  Core
//
//  Created by Łukasz Kasperek on 29/03/2020.
//  Copyright © 2020 Łukasz Kasperek. All rights reserved.
//

import Foundation
import SwiftUI

public class CoreEntry {
    private let dependencies: CoreDependencies
    
    public init(dependencies: CoreDependencies) {
        self.dependencies = dependencies
    }
    
    public func makeInitialView() -> some View {
        return makeRootView()
//        return PlannerView()
    }
    
    private func makeRootView() -> some View {
        let rootRoutes = RootViewModel.Routes(
            exercisesList: makeExercisesList
        )
        return RootView(viewModel: RootViewModel(routes: rootRoutes))
    }
    
    private func makeExercisesList() -> ExercisesListViewModel {
        let routes = ExercisesListViewModel.Routes(
            createExercise: makeExerciseCreation
        )
        return ExercisesListViewModel(
            exerciseStorage: dependencies.exerciseStorage,
            routes: routes
        )
    }
    
    private func makeExerciseCreation() -> ExerciseCreationViewModel {
        return ExerciseCreationViewModel(exerciseStorage: dependencies.exerciseStorage)
    }
}
