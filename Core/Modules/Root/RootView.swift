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
    @State var pace = UIPacePicker.InputState()
    
    var body: some View {
        TabView {
            PacePicker(pace: $pace)
                .tabItem {
                    Text(L10n.Root.Tab.home)
                }
            router.plan()
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
    associatedtype PlanViewType: View
    associatedtype ExerciseListViewType: View
    
    func plan() -> PlanViewType
    func exerciseList() -> ExerciseListViewType
}

// MARK: - Design time

class DTRootRouter: RootRouting {
    @ViewBuilder func plan() -> some View {
        EmptyView()
    }
    
    @ViewBuilder func exerciseList() -> some View {
        EmptyView()
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView(router: DTRootRouter())
    }
}
