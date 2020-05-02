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
        .sheet(isPresented: $isPresenting) {
            ExerciseCreationView(model: .init())
        }
    }
}

struct ExercisesListView_Previews: PreviewProvider {
    static var previews: some View {
        ExercisesListView()
    }
}
