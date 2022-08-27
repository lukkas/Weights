//
//  ExercisesListView.swift
//  Core
//
//  Created by Łukasz Kasperek on 11/04/2020.
//  Copyright © 2020 Łukasz Kasperek. All rights reserved.
//

import SwiftUI

struct ExercisesListView<
    Model: ExerciseListViewModeling,
    Router: ExerciseListViewRouting
>: View {
    @State private var isPresenting = false
    @State private var selectedExercise: ExerciseCellViewModel?
    @StateObject var model: Model
    let router: Router
    
    var body: some View {
        NavigationStack {
            Group {
                if model.cellViewModels.isEmpty {
                    VStack {
                        Text(L10n.ExercisesList.Placeholder.title)
                            .textStyle(.collectionPlaceholderTitle)
                        Text(L10n.ExercisesList.Placeholder.subtitle)
                            .textStyle(.collectionPlaceholderSubtitle)
                    }
                } else {
                    List(
                        model.cellViewModels,
                        selection: $selectedExercise,
                        rowContent: { cellViewModel in
                            Text(cellViewModel.exerciseName)
                                .textStyle(.listItem)
                        }
                    )
                    .listStyle(.inset)
                }
            }
            .navigationBarTitle(L10n.ExercisesList.NavBar.exercises)
            .navigationBarItems(trailing:
                Button(action: { isPresenting.toggle() }, label: {
                    Image(systemName: "plus")
                    .textStyle(.largeButton)
                })
            )
        }
        .sheet(isPresented: $isPresenting) {
            router.exerciseCreation(isPresented: $isPresenting)
        }
    }
}

protocol ExerciseListViewModeling: ObservableObject {
    var cellViewModels: [ExerciseCellViewModel] { get }
}

@MainActor
protocol ExerciseListViewRouting {
    associatedtype ExerciseCreationViewType: View
    
    func exerciseCreation(isPresented: Binding<Bool>) -> ExerciseCreationViewType
}

// MARK: - Design time

class DTExerciseListViewModel: ExerciseListViewModeling {
    init(itemsCount: Int) {
        cellViewModels = .make(count: itemsCount)
    }
    
    let cellViewModels: [ExerciseCellViewModel]
}

class DTExerciseListViewRouter: ExerciseListViewRouting {
    @ViewBuilder func exerciseCreation(isPresented: Binding<Bool>) -> some View {
        EmptyView()
    }
}

struct ExercisesListView_Previews: PreviewProvider {
    static var previews: some View {
        ExercisesListView(
            model: DTExerciseListViewModel(itemsCount: 2),
            router: DTExerciseListViewRouter()
        )
        ExercisesListView(
            model: DTExerciseListViewModel(itemsCount: 0),
            router: DTExerciseListViewRouter()
        )
    }
}
