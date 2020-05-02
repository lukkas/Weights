//
//  ExerciseCreationView.swift
//  Core
//
//  Created by Łukasz Kasperek on 29/03/2020.
//  Copyright © 2020 Łukasz Kasperek. All rights reserved.
//

import Combine
import SwiftUI

struct ExerciseCreationView: View {
    @ObservedObject var model: ExerciseCreationViewModel
    
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
            Spacer()
            Button(action: {}) {
                Text("Add")
                    .frame(minWidth: 256)
                    .foregroundColor(.white)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                    )
                    .foregroundColor(.theme)
            }
        }
        .padding()
        .keyboardAdaptive()
    }
}

struct ExerciseCreationView_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseCreationView(
            model: ExerciseCreationViewModel()
        )
    }
}
