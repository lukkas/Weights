//
//  ExercisesListView.swift
//  Core
//
//  Created by Łukasz Kasperek on 11/04/2020.
//  Copyright © 2020 Łukasz Kasperek. All rights reserved.
//

import SwiftUI

struct ExercisesListView<Model: ExerciseListViewModeling>: View {
    @State private var isPresenting = false
    @State private var selectedExercise: ExerciseCellViewModel?
    @ObservedObject var model: Model
    
    var body: some View {
        NavigationView {
            Group {
                if model.cellViewModels.isEmpty {
                    VStack {
                        Text(L10n.ExercisesList.Placeholder.title)
                            .font(.title)
                        Text(L10n.ExercisesList.Placeholder.subtitle)
                            .font(.subheadline)
                    }
                } else {
                    List(
                        model.cellViewModels,
                        selection: $selectedExercise,
                        rowContent: { cellViewModel in
                            Text(cellViewModel.exerciseName)
                        }
                    )
                    .listStyle(InsetGroupedListStyle())
                }
            }
            .navigationBarTitle(L10n.ExercisesList.NavBar.exercises)
            .navigationBarItems(trailing:
                Button(action: { self.isPresenting.toggle() }, label: {
                    Image(systemName: "plus")
                        .font(.system(size: 24))
                })
            )
        }
        .sheet(isPresented: $isPresenting) {
            ExerciseCreationView(
                model: self.model.routes.createExercise(),
                isPresented: self.$isPresenting
            )
        }
    }
}

class ExercisesListPreviewModel: ExerciseListViewModeling {
    var routes: ExercisesListViewModel.Routes {
        return .init(createExercise: placeholderClosure)
    }
    
    var cellViewModels: [ExerciseCellViewModel] {
        return [
            .init(id: UUID(), exerciseName: "Squat"),
            .init(id: UUID(), exerciseName: "Bench Press")
        ]
    }
}

struct ExercisesListView_Previews: PreviewProvider {
    static var previews: some View {
        ExercisesListView(model: ExercisesListPreviewModel())
    }
}
