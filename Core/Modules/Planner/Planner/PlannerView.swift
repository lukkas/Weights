//
//  PlannerView.swift
//  Core
//
//  Created by Łukasz Kasperek on 04/10/2020.
//  Copyright © 2020 Łukasz Kasperek. All rights reserved.
//

import Combine
import SwiftUI

struct PlannerView<Model: PlannerViewModeling, Router: PlannerRouting>: View {
    @StateObject var model: Model
    @Binding var isPresented: Bool
    @State private var currentlyDragged: PlannerExercise?
    @State private var currentPageIndex: Int = 0
    let router: Router
    
    var body: some View {
        NavigationStack {
            VStack {
                TabView(selection: $currentPageIndex) {
                    ForEach($model.pages) { $page in
                        PlannerPageView(
                            model: $page,
                            currentlyDragged: $currentlyDragged,
                            allPages: $model.pages) { action in
                                switch action {
                                case .addExercise:
                                    model.consume(.addExercise)
                                case let .addSet(exercise):
                                    model.consume(.addSet(exercise, page))
                                case let .addToSupeset(exercise): break
                                case let .removeFromSuperset(exercise): break
                                }
                            }.tag(model.pages.firstIndex(of: page)!)
                    }
                }
                .tabViewStyle(.page)
                
                TrainingBottomBar(
                    workoutName: Binding(
                        get: { model.pages[currentPageIndex].name },
                        set: { model.pages[currentPageIndex].name = $0 }),
                    leftArrowDisabled: leftArrowDisabled,
                    rightArrowDisabled: rightArrowDisabled,
                    onLeftTapped: {
                        withAnimation {
                            currentPageIndex -= 1
                        }
                    },
                    onRightTapped: {
                        withAnimation {
                            currentPageIndex += 1
                        }
                    },
                    onPlusTapped: {
                        withAnimation {
                            model.consume(.addPage)
                            currentPageIndex = model.pages.indices.last!
                        }
                    }
                )
            }
            .background(Color.secondaryBackground)
            .navigationBarTitle(L10n.Planner.title)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Button(L10n.Common.cancel, role: .cancel) {
                        isPresented = false
                    }
                }
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button(L10n.Planner.NavigationBar.save) {
                        model.consume(.save)
                    }
                }
            }
        }
        .onReceive(model.planSaved, perform: {
            isPresented = false
        })
        .onChange(of: currentPageIndex, perform: { pageIndex in
            model.consume(.pageChanged(pageIndex))
        })
        .sheet(
            item: $model.exercisePickerRelay,
            onDismiss: nil
        ) { pickerRelay in
            router.exercisePicker(relay: pickerRelay)
        }
    }
    
    private var leftArrowDisabled: Bool {
        currentPageIndex == model.pages.indices.first
    }
    
    private var rightArrowDisabled: Bool {
        currentPageIndex == model.pages.indices.last
    }
}

@MainActor
protocol PlannerRouting {
    associatedtype ExercisePickerViewType: View
    
    func exercisePicker(relay: ExercisePickerRelay) -> ExercisePickerViewType
}

protocol PlannerViewModeling: ObservableObject {
    var pages: [PlannerPage] { get set }
    var planSaved: AnyPublisher<Void, Never> { get }
    var exercisePickerRelay: ExercisePickerRelay? { get set }
    
    func consume(_ action: PlannerAction)
}

// MARK: - Design time

class DTPlannerPresenter {
//    init(viewModel: PlannerViewModel) {
//        viewModel.pages = [
//            PlannerPageViewModel(name: "A1", exercises: [
//                PlannerExerciseViewModel.dt_squatDeadlift(),
//                PlannerExerciseViewModel.dt_squatDeadlift()
//            ])
//        ]
//    }
}

//class DTPlannerInteractor: PlannerInteracting {
//
//}

struct DTPlannerRouter: PlannerRouting {
    @ViewBuilder func exercisePicker(relay: ExercisePickerRelay) -> some View {
        EmptyView()
    }
}

//struct PlannerView_Previews: PreviewProvider {
//    static var previews: some View {
//        let model = PlannerViewModel(
//            interactor: DTPlannerInteractor(),
//            isPresented: .constant(true)
//        )
//        let presenter = DTPlannerPresenter(viewModel: model)
//        PlannerView(
//            model: model,
//            presenter: presenter,
//            router: DTPlannerRouter()
//        )
//    }
//}
