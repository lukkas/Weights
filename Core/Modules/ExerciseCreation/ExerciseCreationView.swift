//
//  ExerciseCreationView.swift
//  Core
//
//  Created by Łukasz Kasperek on 29/03/2020.
//  Copyright © 2020 Łukasz Kasperek. All rights reserved.
//

import Combine
import SwiftUI

struct ExerciseCreationView<Model: ExerciseCreationViewModeling>: View {
    @ObservedObject var model: Model
    @Binding var isPresented: Bool
    
    var body: some View {
        Form {
            TextField("Exercise Name", text: $model.name)
            Section(
                header: Text(
                    verbatim: L10n.ExerciseCreation.MetricSelector.title
                )
                    .font(.headline),
                footer: Text(
                    verbatim:
                        L10n.ExerciseCreation.MetricSelector.comment
                )
            ) {
                optionButton(volumeUnit: .reps)
                optionButton(volumeUnit: .duration)
            }
            Section(
                header: Text("Laterality")
                    .font(.headline),
                footer: Text("Siusiak")
            ) {
                
            }
        }
    }
    
    @ViewBuilder private func optionButton(
        volumeUnit: Exercise.VolumeUnit
    ) -> some View {
        Button(action: { model.volumeUnit = volumeUnit }, label: {
            HStack {
                Image(systemName: volumeUnit.imageName)
                    .foregroundColor(
                        model.volumeUnit == volumeUnit ? .theme : .label
                    )
                Text(volumeUnit.title)
                    .foregroundColor(
                        model.volumeUnit == volumeUnit ? .theme : .label
                    )
                if model.volumeUnit == volumeUnit {
                    Spacer()
                    Image(systemName: "checkmark")
                        .foregroundColor(.theme)
                }
            }
        })
    }
}

private extension Exercise.VolumeUnit {
    var title: String {
        switch self {
        case .duration: return L10n.ExerciseCreation.MetricSelector.duration
        case .reps: return L10n.ExerciseCreation.MetricSelector.reps
        }
    }
    
    var imageName: String {
        switch self {
        case .duration: return "clock"
        case .reps: return "number.circle"
        }
    }
}

class ExerciseCreationPreviewModel: ExerciseCreationViewModeling {
    @Published var name: String = ""
    @Published var volumeUnit: Exercise.VolumeUnit? = nil
    @Published var laterality: Exercise.Laterality? = nil
}

struct ExerciseCreationView_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseCreationView(
            model: ExerciseCreationPreviewModel(),
            isPresented: .constant(true)
        )
        .previewDevice("iPhone 11 Pro")
    }
}
