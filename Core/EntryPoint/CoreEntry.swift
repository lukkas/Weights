//
//  CoreEntry.swift
//  Core
//
//  Created by Łukasz Kasperek on 29/03/2020.
//  Copyright © 2020 Łukasz Kasperek. All rights reserved.
//

import Foundation
import SwiftUI

public class CoreEntry: RootRouting, ExerciseListViewRouting, PlanRouting, PlannerRouting {    
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
    
    @ViewBuilder func plan() -> some View {
        PlanView(router: self)
    }
    
    @ViewBuilder func exerciseList() -> some View {
        let model = ExercisesListViewModel(exerciseStorage: dependencies.exerciseStorage)
        ExercisesListView(
            model: model,
            router: self
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
    
    // MARK: - PlanRouting
    
    @ViewBuilder func planner(isPresented: Binding<Bool>) -> some View {
        let model = PlannerViewModel()
        PlannerView(model: model, router: self)
    }
    
    // MARK: - PlannerRouting
    
    @ViewBuilder func exercisePicker(relay: ExercisePickerRelay) -> some View {
        let model = ExercisePickerViewModel(
            exerciseStorage: dependencies.exerciseStorage,
            pickedRelay: relay
        )
        ExercisePickerView(model: model)
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
