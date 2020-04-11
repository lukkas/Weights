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
        @Published var laterality: GraphicalSelector.Model
        
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
                    .init(
                        image: Image(systemName: "tray.fill"),
                        description: L10n.ExerciseCreation.LateralitySelector.bilateral
                    ),
                    .init(
                        image: Image(systemName: "folder.fill"),
                        description: L10n.ExerciseCreation.LateralitySelector.unilateralSimultaneous
                    ),
                    .init(
                        image: Image(systemName: "paperplane.fill"),
                        description: L10n.ExerciseCreation.LateralitySelector.unilateralSeparate
                    )
                ],
                selectedIndex: 0
            )
        }
    }
}

struct ExerciseCreationView: View {
    @ObservedObject var model: Model
    
    var body: some View {
        VStack(spacing: 16) {
            TextField(L10n.ExerciseCreation.NameField.title, text: $model.name)
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .foregroundColor(.background)
            )
            BiSelector(model: $model.metric)
            GraphicalSelector(model: $model.laterality)
        }
        .padding()
    }
}

struct ExerciseCreationView_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseCreationView(model: ExerciseCreationView.Model())
    }
}
