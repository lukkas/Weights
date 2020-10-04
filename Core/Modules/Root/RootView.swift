//
//  RootView.swift
//  Core
//
//  Created by Łukasz Kasperek on 11/04/2020.
//  Copyright © 2020 Łukasz Kasperek. All rights reserved.
//

import SwiftUI

struct RootView: View {
    var viewModel: RootViewModel
    
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
            ExercisesListView(model: viewModel.routes.exercisesList())
                .tabItem {
                    Text(L10n.Root.Tab.exercises)
                }
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView(
            viewModel: RootViewModel(
                routes: .init(exercisesList: placeholderClosure)
            )
        )
    }
}
