//
//  PlanView.swift
//  Core
//
//  Created by Łukasz Kasperek on 21/11/2021.
//  Copyright © 2021 Łukasz Kasperek. All rights reserved.
//

import SwiftUI

struct PlanView<
    Model: PlanViewModeling, Router: PlanRouting
>: View {
    @State var isPresentingPlanner = false
    @ObservedObject var model: Model
    
    let router: Router
    
    var body: some View {
        Button {
            isPresentingPlanner = true
        } label: {
            Text("Show planner")
        }
        .sheet(isPresented: $isPresentingPlanner) {
            router.planner(isPresented: $isPresentingPlanner)
        }
    }
}

protocol PlanViewModeling: ObservableObject {
    
}

@MainActor
protocol PlanRouting {
    associatedtype PlannerViewType: View
    
    func planner(isPresented: Binding<Bool>) -> PlannerViewType
}

// MARK: - Design time

class DTPlanViewModel: PlanViewModeling {
    
}

struct DTPlanRouter: PlanRouting {
    @ViewBuilder func planner(isPresented: Binding<Bool>) -> some View {
        EmptyView()
    }
}

struct PlanView_Previews: PreviewProvider {
    static var previews: some View {
        PlanView(
            model: DTPlanViewModel(),
            router: DTPlanRouter()
        )
    }
}
