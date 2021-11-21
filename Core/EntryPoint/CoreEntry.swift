//
//  CoreEntry.swift
//  Core
//
//  Created by Łukasz Kasperek on 29/03/2020.
//  Copyright © 2020 Łukasz Kasperek. All rights reserved.
//

import Foundation
import SwiftUI

public class CoreEntry: RootRouting, ExerciseListViewRouting {
    private let dependencies: CoreDependencies
    
    public init(dependencies: CoreDependencies) {
        self.dependencies = dependencies
    }
    
    public func makeInitialView() -> some View {
        return makeRootView()
//        return PlannerView()
//        return ParameterFieldWrapper()
    }
    
    @ViewBuilder private func makeRootView() -> some View {
        RootView(router: self)
    }
    
    // MARK: - RootRouting
    
    @ViewBuilder func exerciseList() -> some View {
        let model = ExercisesListViewModel(exerciseStorage: dependencies.exerciseStorage)
        let router = DTExerciseListViewRouter()
        ExercisesListView(
            model: model,
            router: router
        )
    }
    
    // MARK: - ExerciseListViewRouting
    
    @ViewBuilder func exerciseCreation(isPresented: Binding<Bool>) -> some View {
        let model = ExerciseCreationViewModel(exerciseStorage: dependencies.exerciseStorage)
        ExerciseCreationView(
            model: model,
            isPresented: isPresented
        )
    }
    
    private func makeExercisesList() -> ExercisesListViewModel {
        return ExercisesListViewModel(
            exerciseStorage: dependencies.exerciseStorage
        )
    }
    
    private func makeExerciseCreation() -> ExerciseCreationViewModel {
        return ExerciseCreationViewModel(exerciseStorage: dependencies.exerciseStorage)
    }
}

struct ParameterFieldWrapper: View {
    @State var isShowingPlanner = false
    
    var body: some View {
        Button {
            isShowingPlanner.toggle()
        } label: {
            Text("Show planner")
        }
        .sheet(
            isPresented: $isShowingPlanner,
            content: {
                PlannerView(model: PlannerViewModel(), router: DTPlannerRouter())
            }
        )
//        PlannerExerciseView(model: PlannerExerciseViewModel(exercise: .stubbed()))
    }
}

private extension Exercise {
    static func stubbed() -> Exercise {
        return Exercise(
            id: UUID(),
            name: "Squat",
            metric: .reps,
            laterality: .bilateral
        )
    }
}
