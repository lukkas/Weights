//
//  PlannerExerciseView.swift
//  Core
//
//  Created by Łukasz Kasperek on 11/10/2020.
//  Copyright © 2020 Łukasz Kasperek. All rights reserved.
//

import SwiftUI

protocol PlannerExerciseViewModeling: ObservableObject {
    var name: String { get }
    var addedSets: [AggregatePlannerSetCellModel] { get set }
    var adder: PlannerSetCellModel { get set }
}

struct PlannerExerciseView<Model: PlannerExerciseViewModeling>: View {
    @ObservedObject var model: Model
    
    var body: some View {
        VStack {
            HStack {
                Text(model.name)
                Spacer()
                Button("Pace") {
                    
                }
                .buttonStyle(.borderedProminent)
                .tint(.weightGreen)
            }
            VStack {
                ForEach($model.addedSets) { sets in
                    AggregatePlannerSetCell(model: sets)
                }
//                Divider()
                PlannerSetCell(model: $model.adder)
            }
        }
        .padding(10)
        .background(Color.background)
        .cornerRadius(10)
    }
}

struct PlannerExerciseView_Previews: PreviewProvider {
    class PreviewModel: PlannerExerciseViewModeling {
        let name: String = "Squat"
        var addedSets: [AggregatePlannerSetCellModel] = [
            AggregatePlannerSetCellModel(
                reps: 5,
                weight: 5
            )
        ]
        var adder = PlannerSetCellModel()
    }
    
    static var previews: some View {
        PlannerExerciseView(model: PreviewModel())
            .cellPreview()
    }
}
