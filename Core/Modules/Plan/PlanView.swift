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
        NavigationStack {
            ZStack {
                Color.groupedBackground.ignoresSafeArea()
                Group {
                    if model.currentPlan == nil && model.otherPlans.isEmpty {
                        VStack {
                            Text(L10n.Plans.Collection.Placeholder.title)
                                .multilineTextAlignment(TextAlignment.center)
                                .textStyle(.collectionPlaceholderTitle)
                            Text(L10n.Plans.Collection.Placeholder.subtitle)
                                .textStyle(.collectionPlaceholderSubtitle)
                        }
                    } else {
                        ScrollView {
                            LazyVStack {
                                if let current = model.currentPlan {
                                    Section {
                                        ActivePlanCell(model: current)
                                    } header: {
                                        sectionHeader(
                                            titled: L10n.Plans.Collection.SectionHeader.currentPlan
                                        )
                                    }
                                    .padding(.horizontal)
                                }
                                if !model.otherPlans.isEmpty {
                                    Section {
                                        ForEach(model.otherPlans) { plan in
                                            PlanCell(model: plan)
                                        }
                                    } header: {
                                        sectionHeader(
                                            titled: L10n.Plans.Collection.SectionHeader.otherPlans
                                        )
                                    }
                                    .padding(.horizontal)
                                }
                            }
                        }
                    }
                }
            }
            .navigationBarTitle(L10n.Plans.NavBar.title)
            .navigationBarItems(trailing:
                Button(action: { isPresentingPlanner.toggle() }, label: {
                    Image(systemName: "plus")
                    .textStyle(.largeButton)
                })
            )
        }
        .sheet(isPresented: $isPresentingPlanner) {
            router.planner(isPresented: $isPresentingPlanner)
        }
    }
    
    @ViewBuilder private func sectionHeader(titled title: String) -> some View {
        Text(title)
            .foregroundColor(.secondaryLabel)
            .textStyle(.sectionTitle)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 8)
    }
}

protocol PlanViewModeling: ObservableObject {
    var currentPlan: ActivePlanCellModel? { get }
    var otherPlans: [PlanCellModel] { get }
}

@MainActor
protocol PlanRouting {
    associatedtype PlannerViewType: View
    
    func planner(isPresented: Binding<Bool>) -> PlannerViewType
}

// MARK: - Design time

class DTPlanViewModel: PlanViewModeling {
    var currentPlan: ActivePlanCellModel?
    var otherPlans: [PlanCellModel]
    
    init(
        currentPlan: ActivePlanCellModel? = nil,
        otherPlans: [PlanCellModel] = []
    ) {
        self.currentPlan = currentPlan
        self.otherPlans = otherPlans
    }
}

struct DTPlanRouter: PlanRouting {
    @ViewBuilder func planner(isPresented: Binding<Bool>) -> some View {
        EmptyView()
    }
}

struct PlanView_Previews: PreviewProvider {
    static var previews: some View {
        PlanView(
            model: DTPlanViewModel(
                currentPlan: .dt_upperLower(),
                otherPlans: [
                    .dt_pushPullLegs(),
                    .dt_pushPullLegs()
                ]
            ),
            router: DTPlanRouter()
        )
        .previewDisplayName("Current and others")
        PlanView(
            model: DTPlanViewModel(),
            router: DTPlanRouter()
        )
        .previewDisplayName("Empty state")
    }
}
