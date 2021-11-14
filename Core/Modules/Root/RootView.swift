//
//  RootView.swift
//  Core
//
//  Created by Łukasz Kasperek on 11/04/2020.
//  Copyright © 2020 Łukasz Kasperek. All rights reserved.
//

import SwiftUI

struct RootView<Model: RootViewModeling>: View {
    @StateObject var model: Model
    
    var body: some View {
        TabView {
            Color.red
                .tabItem {
                    Text(L10n.Root.Tab.home)
                }
            Text("2")
                .tabItem {
                    Text(L10n.Root.Tab.plan)
                }
//            ExercisesListView(model: model.routes.exercisesList())
//                .tabItem {
//                    Text(L10n.Root.Tab.exercises)
//                }
        }
    }
}

// MARK: - Model

struct RootRoutes<ExerciseListViewModelType: ExerciseListViewModeling> {
    let exercisesList: () -> ExerciseListViewModelType
}

protocol RootViewModeling: ObservableObject {
    associatedtype ExerciseListViewModelType: ExerciseListViewModeling
    
    var routes: RootRoutes<ExerciseListViewModelType> { get }
}

// MARK: - Design time

class DTRootViewModel: RootViewModeling {
    var routes: RootRoutes<DTExerciseListViewModel> = .init(
        exercisesList: { DTExerciseListViewModel() }
    )
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView(model: DTRootViewModel())
    }
}
