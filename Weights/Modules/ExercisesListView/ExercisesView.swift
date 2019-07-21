//
//  ExercisesView.swift
//  Weights
//
//  Created by Łukasz Kasperek on 20/07/2019.
//  Copyright © 2019 Łukasz Kasperek. All rights reserved.
//

import SwiftUI

struct ExercisesView: View {
    @State var isPresentingCreationView: Bool = false
    let model: ExercisesListModel
    
    var body: some View {
        NavigationView {
            ExercisesListView(model: model)
                .navigationBarTitle("Exercises")
                .navigationBarItems(trailing: Button(
                    action: {
                        self.isPresentingCreationView = true
                    },
                    label: {
                        Image(systemName: "plus").imageScale(.large)
                })
            )
        }
        .sheet(isPresented: $isPresentingCreationView) {
            ExerciseCreationView(model: ExerciseCreationViewModel())
        }
    }
}

#if DEBUG
struct ExercisesView_Previews: PreviewProvider {
    static var previews: some View {
        ExercisesView(model: .sample)
    }
}
#endif
