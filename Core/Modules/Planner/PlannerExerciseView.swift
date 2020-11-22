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
}

struct PlannerExerciseView<Model: PlannerExerciseViewModeling>: View {
    @ObservedObject var model: Model
    
    var body: some View {
        VStack {
            HStack {
                Text(model.name)
                Spacer()
                ParameterGauge(value: "RPE", themeColor: .weightGreen)
                ParameterGauge(value: "Pace", themeColor: .weightBlue)
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
    }
    
    static var previews: some View {
        PlannerExerciseView(model: PreviewModel())
            .cellPreview()
    }
}
