//
//  ExerciseCreationView.swift
//  Core
//
//  Created by Łukasz Kasperek on 29/03/2020.
//  Copyright © 2020 Łukasz Kasperek. All rights reserved.
//

import SwiftUI

extension ExerciseCreationView {
    class Model: ObservableObject {
        @Published var name: String = ""
        @Published var metric: BiSelector.Model
        @Published var laterality: VerticalSelector.Model
        
        init() {
            metric = BiSelector.Model(
                options: [
                    L10n.ExerciseCreation.MetricSelector.reps,
                    L10n.ExerciseCreation.MetricSelector.duration
                ],
                selectedIndex: 0
            )
            laterality = .init(
                options: [
                    L10n.ExerciseCreation.LateralitySelector.bilateral,
                    L10n.ExerciseCreation.LateralitySelector.unilateralSimultaneous,
                    L10n.ExerciseCreation.LateralitySelector.unilateralSeparate
                ],
                selectedIndex: 1
            )
        }
    }
}

struct ExerciseCreationView: View {
    @ObservedObject var model: Model
    
    var body: some View {
        VStack(spacing: 24) {
            TextField(L10n.ExerciseCreation.NameField.title, text: $model.name)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .foregroundColor(.background)
                        .outerDepthShadow()
            )
            BiSelector(model: $model.metric)
            VerticalSelector(model: $model.laterality)
        }
    }
}

struct ExerciseCreationView_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseCreationView(model: ExerciseCreationView.Model())
    }
}
