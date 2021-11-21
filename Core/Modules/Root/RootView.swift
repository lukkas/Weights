//
//  RootView.swift
//  Core
//
//  Created by Łukasz Kasperek on 11/04/2020.
//  Copyright © 2020 Łukasz Kasperek. All rights reserved.
//

import SwiftUI

struct RootView<Router: RootRouting>: View {
    let router: Router
    
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
            router.exerciseList()
                .tabItem {
                    Text(L10n.Root.Tab.exercises)
                }
        }
    }
}

protocol RootRouting {
    associatedtype ExerciseListViewType: View
    
    func exerciseList() -> ExerciseListViewType
}

// MARK: - Design time

class DTRootRouter: RootRouting {
    @ViewBuilder func exerciseList() -> some View {
        EmptyView()
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView(router: DTRootRouter())
    }
}
