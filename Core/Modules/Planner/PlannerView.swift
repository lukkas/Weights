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
    var leftArrowEnabled: Bool { get }
    
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

//struct PlannerView: View {
//    var body: some View {
//        NavigationView {
//            VStack {
//                HStack {
//                    Text("Kutas")
//                }
//
//                TabView {
//                    ScrollView {
//                        ForEach(0 ..< 10) { _ in
//                            Button(action: {}, label: {
//                                Text(L10n.Planner.addDay)
//                                    .foregroundColor(.contrastLabel)
//                            })
//                            .padding(.vertical, 12)
//                            .frame(maxWidth: 800)
//                            .background(Color.red.cornerRadius(8))
//                            .padding()
//                            .onDrag({
//                                NSItemProvider(object: URL(string: "http://apple.com")! as NSURL)
//                            })
//                        }
//                    }
//
//                    Button(action: {}, label: {
//                        Text(L10n.Planner.addDay)
//                    })
//                    .padding(.vertical, 12)
//                    .frame(maxWidth: 800)
//                    .background(Color.theme.cornerRadius(8))
//                    .padding()
//                }
//                .tabViewStyle(PageTabViewStyle())
//                .background(Color(.tertiarySystemBackground))
//            }
//            .navigationBarTitle(L10n.Planner.title)
//        }
//    }
//}

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
    var leftArrowEnabled: Bool { true }
    
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
