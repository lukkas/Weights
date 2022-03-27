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
    @State var index: Int = 0
    let router: Router
    @State var isPresentingExerciseList = false
    
    var body: some View {
        NavigationView {
            VStack {
                TabView(selection: $model.visibleUnit) {
                    ForEach(model.trainingUnits.indices) { index in
                        PlannerPageView(
                            model: model.trainingUnits[index],
                            addExerciseTapped: {
                                model.addExerciseTapped()
                            })
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .automatic))
                .id(model.trainingUnits)
                
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

struct PlannerPageView<ExerciseViewModel: PlannerExerciseViewModeling>: View {
    let model: TrainingUnitModel<ExerciseViewModel>
    let addExerciseTapped: () -> Void
    
    var body: some View {
        ScrollView {
            Color.clear
            LazyVStack(spacing: 16) {
                ForEach(model.exercises) { exercise in
                    PlannerExerciseView(model: exercise)
                        .onDrag({
                            NSItemProvider(object: exercise.draggingArchive())
                        })
                        .padding(.horizontal, 16)
                }
                Button {
                    addExerciseTapped()
                } label: {
                    Text("Add exercise")
                        .font(.system(
                            size: 18,
                            weight: .medium,
                            design: .rounded
                        ))
                        .frame(maxWidth: .infinity)
                }
                .padding(.horizontal, 16)
                .buttonStyle(.borderedProminent)
            }
            Color.clear
        }
    }
}

protocol PlannerViewModeling: ObservableObject {
    associatedtype ExerciseViewModelType: PlannerExerciseViewModeling
    
    var trainingUnits: [TrainingUnitModel<ExerciseViewModelType>] { get }
    var visibleUnit: Int { get set }
    var currentUnitName: String { get set }
    var exercisePickerRelay: ExercisePickerRelay? { get set }
    var leftArrowDisabled: Bool { get }
    var rightArrowDisabled: Bool { get }
    
    func addExerciseTapped()
    func leftArrowTapped()
    func rightArrowTapped()
    func plusTapped()
}

struct TrainingUnitModel<ExerciseModel: PlannerExerciseViewModeling>: Identifiable, Hashable {
    let id = UUID()
    var name: String
    private(set) var exercises: [ExerciseModel]
    
    init(name: String, exercises: [ExerciseModel] = []) {
        self.name = name
        self.exercises = exercises
    }
    
    mutating func addExercises(_ models: [ExerciseModel]) {
        exercises.append(contentsOf: models)
    }
}

protocol PlannerRouting {
    associatedtype ExercisePickerViewType: View
    
    func exercisePicker(relay: ExercisePickerRelay) -> ExercisePickerViewType
}

// MARK: - Design time

class DTPlannerViewModel: PlannerViewModeling {
    typealias ExerciseViewModelType = DTPlannerExerciseViewModel
    
    let trainingUnits: [TrainingUnitModel<DTPlannerExerciseViewModel>] = [
        TrainingUnitModel(name: "A1", exercises: [
            DTPlannerExerciseViewModel(),
            DTPlannerExerciseViewModel()
        ])
    ]
    @Published var visibleUnit: Int = 0
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
