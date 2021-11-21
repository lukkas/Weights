//
//  PlannerView.swift
//  Core
//
//  Created by Łukasz Kasperek on 04/10/2020.
//  Copyright © 2020 Łukasz Kasperek. All rights reserved.
//

import SwiftUI

struct PlannerView<Model: PlannerViewModeling, Router: PlannerRouting>: View {
    @ObservedObject var model: Model
    let router: Router
    @State var isPresentingExerciseList = false
    
    var body: some View {
        TabView(selection: $model.visibleUnit) {
            ForEach(model.trainingUnits) { unit in
                VStack {
                    ScrollView {
                        Color.clear
                        LazyVStack(spacing: 16) {
                            ForEach(unit.exercises) { exercise in
                                PlannerExerciseView(model: exercise)
                                    .padding(.horizontal, 16)

                            }
                            Button {
                                model.addExerciseTapped()
                            } label: {
                                Text("Add exercise")
                            }
                        }
                        Color.clear
                    }
                    TrainingBottomBar(
                        workoutName: $model.currentUnitName,
                        onLeftTapped: model.leftArrowTapped,
                        onRightTapped: model.rightArrowTapped,
                        onPlusTapped: model.plusTapped
                    )
                }
                .background(Color.secondaryBackground)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .automatic))
        .navigationBarTitle(L10n.Planner.title)
    }
}

protocol PlannerViewModeling: ObservableObject {
    associatedtype ExerciseViewModelType: PlannerExerciseViewModeling
    
    var trainingUnits: [TrainingUnitModel<ExerciseViewModelType>] { get }
    var visibleUnit: Int { get set }
    var currentUnitName: String { get set }
    
    func addExerciseTapped()
    func leftArrowTapped()
    func rightArrowTapped()
    func plusTapped()
}

struct TrainingUnitModel<ExerciseModel: PlannerExerciseViewModeling>: Identifiable {
    let id = UUID()
    var name: String
    let exercises: [ExerciseModel]
}

protocol PlannerRouting {
    associatedtype ExerciseCreationViewType = View
    
    func exerciseCreation(isPresented: Binding<Bool>) -> ExerciseCreationViewType
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
    @ViewBuilder func exerciseCreation(isPresented: Binding<Bool>) -> some View {
        EmptyView()
    }
}

struct PlannerView_Previews: PreviewProvider {    
    static var previews: some View {
        PlannerView(model: DTPlannerViewModel(), router: DTPlannerRouter())
    }
}
