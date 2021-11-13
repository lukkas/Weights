//
//  PlannerView.swift
//  Core
//
//  Created by Łukasz Kasperek on 04/10/2020.
//  Copyright © 2020 Łukasz Kasperek. All rights reserved.
//

import SwiftUI

struct PlannerView<Model: PlannerViewModeling>: View {
    @ObservedObject var model: Model
    
    var body: some View {
        TabView(selection: $model.visibleUnit) {
            ForEach(model.trainingUnits) { unit in
                VStack {
                    ScrollView {
                        LazyVStack {
                            ForEach(unit.exercises) { exercise in
                                PlannerExerciseView(model: exercise)
                                    .padding()
                            }
                        }
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
    
    func leftArrowTapped()
    func rightArrowTapped()
    func plusTapped()
}

struct TrainingUnitModel<ExerciseModel: PlannerExerciseViewModeling>: Identifiable {
    let id = UUID()
    let name: String
    let exercises: [ExerciseModel]
}

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

class Preview_PlannerViewModel: PlannerViewModeling {
    typealias ExerciseViewModelType = Preview_PlannerExerciseViewModel
    
    let trainingUnits: [TrainingUnitModel<Preview_PlannerExerciseViewModel>] = [
        TrainingUnitModel(name: "A1", exercises: [
            Preview_PlannerExerciseViewModel(),
            Preview_PlannerExerciseViewModel()
        ])
    ]
    @Published var visibleUnit: Int = 0
    @Published var currentUnitName: String = "Upper A"
    
    func leftArrowTapped() {
        
    }
    
    func rightArrowTapped() {
        
    }
    
    func plusTapped() {
        
    }
}

struct PlannerView_Previews: PreviewProvider {
//    fileprivate class PreviewModel: PlannerViewModeling {
//        
//    }
    
    static var previews: some View {
        PlannerView(model: Preview_PlannerViewModel())
    }
}
