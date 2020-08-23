//
//  ExercisesListView.swift
//  Core
//
//  Created by Łukasz Kasperek on 11/04/2020.
//  Copyright © 2020 Łukasz Kasperek. All rights reserved.
//

import SwiftUI

struct ExercisesListView: View {
    @State private var isPresenting = false
    var viewModel: ExercisesListViewModel
    
    var body: some View {
        NavigationView {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
                .navigationBarTitle(L10n.ExercisesList.NavBar.exercises)
                .navigationBarItems(trailing:
                    Button(action: { self.isPresenting.toggle() }, label: {
                        Image(systemName: "plus")
                            .font(.system(size: 24))
                    })
            )
        }
        .fullScreenCover(isPresented: /*@START_MENU_TOKEN@*/.constant(true)/*@END_MENU_TOKEN@*/, onDismiss: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=On Dismiss@*/{}/*@END_MENU_TOKEN@*/) {
            /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Content@*/Text("Placeholder")/*@END_MENU_TOKEN@*/
        }
        .sheet(isPresented: $isPresenting) {
            ExerciseCreationView(
                model: self.viewModel.routes.createExercise(),
                isPresented: self.$isPresenting
            )
        }
    }
}

struct ExercisesListView_Previews: PreviewProvider {
    static var previews: some View {
        ExercisesListView(viewModel: ExercisesListViewModel(
            exerciseStorage: PlaceholderExerciseStorage(),
            routes: .init(createExercise: placeholderClosure)
            )
        )
    }
}

func placeholderClosure<T>() -> T { fatalError() }
func placeholderClosure<P, T>(arg1: P) ->  T { fatalError() }
