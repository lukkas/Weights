//
//  PlannerView.swift
//  Core
//
//  Created by Łukasz Kasperek on 04/10/2020.
//  Copyright © 2020 Łukasz Kasperek. All rights reserved.
//

import SwiftUI

struct PlannerView<Presenter: PlannerPresenting, Router: PlannerRouting>: View {
    @StateObject var model: PlannerViewModel
    let presenter: Presenter
    @State private var currentlyDragged: PlannerExerciseViewModel?
    let router: Router
    
    var body: some View {
        NavigationStack {
            VStack {
                TabView(selection: $model.visiblePage) {
                    ForEach(model.pages.indices, id: \.self) { index in
                        PlannerPageView(
                            model: model.pages[index],
                            currentlyDragged: $currentlyDragged,
                            allPages: $model.pages,
                            addExerciseTapped: {
                                presenter.addExerciseTapped()
                            })
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .automatic))
                .id(model.pages)
                
                TrainingBottomBar(
                    workoutName: $model.currentUnitName,
                    leftArrowDisabled: model.leftArrowDisabled,
                    rightArrowDisabled: model.rightArrowDisabled,
                    onLeftTapped: presenter.leftArrowTapped,
                    onRightTapped: presenter.rightArrowTapped,
                    onPlusTapped: presenter.plusTapped
                )
            }
            .background(Color.secondaryBackground)
            .navigationBarTitle(L10n.Planner.title)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Button(L10n.Common.cancel, role: .cancel) {
                        presenter.cancelNavigationButtonTapped()
                    }
                }
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button(L10n.Planner.NavigationBar.save) {
                        presenter.saveNavigationButtonTapped()
                    }
                }
            }
        }
        .sheet(
            item: $model.exercisePickerRelay,
            onDismiss: nil
        ) { pickerRelay in
            router.exercisePicker(relay: pickerRelay)
        }
    }
}

protocol PlannerPresenting {
    func cancelNavigationButtonTapped()
    func saveNavigationButtonTapped()
    
    func plusTapped()
    func leftArrowTapped()
    func rightArrowTapped()
    func addExerciseTapped()
}

@MainActor
protocol PlannerRouting {
    associatedtype ExercisePickerViewType: View
    
    func exercisePicker(relay: ExercisePickerRelay) -> ExercisePickerViewType
}

// MARK: - Design time

class DTPlannerPresenter: PlannerPresenting {
    init(viewModel: PlannerViewModel) {
        viewModel.pages = [
            PlannerPageViewModel(name: "A1", exercises: [
                PlannerExerciseViewModel.dt_squatDeadlift(),
                PlannerExerciseViewModel.dt_squatDeadlift()
            ])
        ]
    }
    
    func cancelNavigationButtonTapped() {}
    func saveNavigationButtonTapped() {}
    func plusTapped() {}
    func leftArrowTapped() {}
    func rightArrowTapped() {}
    func addExerciseTapped() {}
}

class DTPlannerInteractor: PlannerInteracting {
    
}

struct DTPlannerRouter: PlannerRouting {
    @ViewBuilder func exercisePicker(relay: ExercisePickerRelay) -> some View {
        EmptyView()
    }
}

struct PlannerView_Previews: PreviewProvider {
    static var previews: some View {
        let model = PlannerViewModel(
            interactor: DTPlannerInteractor(),
            isPresented: .constant(true)
        )
        let presenter = DTPlannerPresenter(viewModel: model)
        PlannerView(
            model: model,
            presenter: presenter,
            router: DTPlannerRouter()
        )
    }
}
