//
//  PlannerView.swift
//  Core
//
//  Created by Łukasz Kasperek on 04/10/2020.
//  Copyright © 2020 Łukasz Kasperek. All rights reserved.
//

import SwiftUI

struct PlannerView<Model: PlannerViewModeling, Router: PlannerRouting>: View {
    @StateObject var model: Model
    let router: Router
    
    var body: some View {
        NavigationView {
            VStack {
                TabView(selection: $model.visiblePage) {
                    ForEach(model.pages.indices) { index in
                        PlannerPageView(
                            model: model.pages[index],
                            draggingDelegate: model,
                            addExerciseTapped: {
                                model.addExerciseTapped()
                            },
                            draggingStarted: { exercise in
                                model.startDragging(of: exercise)
                            })
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .automatic))
                .id(model.pages)
                
                TrainingBottomBar(
                    workoutName: $model.currentUnitName,
                    leftArrowDisabled: model.leftArrowDisabled,
                    rightArrowDisabled: model.rightArrowDisabled,
                    onLeftTapped: model.leftArrowTapped,
                    onRightTapped: model.rightArrowTapped,
                    onPlusTapped: model.plusTapped
                )
            }
            .background(Color.secondaryBackground)
            .navigationBarTitle(L10n.Planner.title)
        }
        .sheet(
            item: $model.exercisePickerRelay,
            onDismiss: nil
        ) { pickerRelay in
            router.exercisePicker(relay: pickerRelay)
        }
    }
}

protocol PlannerViewModeling: ObservableObject, PlannerDropControllerDelegate {
    var pages: [PlannerPageViewModel<ExerciseViewModel>] { get }
    var visiblePage: Int { get set }
    var currentUnitName: String { get set }
    var exercisePickerRelay: ExercisePickerRelay? { get set }
    var leftArrowDisabled: Bool { get }
    var rightArrowDisabled: Bool { get }
    
    func addExerciseTapped()
    func leftArrowTapped()
    func rightArrowTapped()
    func plusTapped()
    func startDragging(of item: ExerciseViewModel)
}

protocol PlannerRouting {
    associatedtype ExercisePickerViewType: View
    
    func exercisePicker(relay: ExercisePickerRelay) -> ExercisePickerViewType
}

// MARK: - Design time

class DTPlannerViewModel: PlannerViewModeling {
    typealias ExerciseViewModel = DTPlannerExerciseViewModel
    typealias ExerciseViewModelType = DTPlannerExerciseViewModel
    
    let pages: [PlannerPageViewModel<DTPlannerExerciseViewModel>] = [
        PlannerPageViewModel(name: "A1", exercises: [
            DTPlannerExerciseViewModel(),
            DTPlannerExerciseViewModel()
        ])
    ]
    @Published var visiblePage: Int = 0
    @Published var currentUnitName: String = "Upper A"
    @Published var exercisePickerRelay: ExercisePickerRelay?
    var leftArrowDisabled: Bool { false }
    var rightArrowDisabled: Bool { false }
    
    func addExerciseTapped() {
        
    }
    
    func leftArrowTapped() {
        
    }
    
    func rightArrowTapped() {
        
    }
    
    func plusTapped() {
        
    }
    
    func startDragging(of item: DTPlannerExerciseViewModel) {
        
    }
    
    func currentlyDraggedItem(wasDraggedOver target: PlannerDraggingTarget<DTPlannerExerciseViewModel>) {
        
    }
}

struct DTPlannerRouter: PlannerRouting {
    @ViewBuilder func exercisePicker(relay: ExercisePickerRelay) -> some View {
        EmptyView()
    }
}

//struct PlannerView_Previews: PreviewProvider {
//    static var previews: some View {
//        PlannerView(model: DTPlannerViewModel(), router: DTPlannerRouter())
//    }
//}
