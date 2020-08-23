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
                header: Text("Metric")
                    .font(.headline),
                footer: Text("Siusiak")
            ) {
                HStack {
                    optionButton(volumeUnit: .reps)
                    Image(systemName: "arrow.left.arrow.right")
                    optionButton(volumeUnit: .duration)
                }
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
            VStack {
                volumeUnit.image.foregroundColor(
                    model.volumeUnit == volumeUnit ? .white : nil
                )
                Spacer()
                Text(volumeUnit.title).foregroundColor(
                    model.volumeUnit == volumeUnit ? .white : nil
                )
            }
        })
        .buttonStyle(PlainButtonStyle())
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            model.volumeUnit == volumeUnit
                ? Color.theme.cornerRadius(8)
                : nil
        )
        .overlay(
            model.volumeUnit == volumeUnit
                ? nil
                : RoundedRectangle(cornerRadius: 8).stroke(Color.black, lineWidth: 1)
        )
    }
    
    private let volumeUnits = Exercise.VolumeUnit.allCases
    private let lateralityOptions = Exercise.Laterality.allCases
}

private extension Exercise.VolumeUnit {
    var title: String {
        switch self {
        case .duration: return L10n.ExerciseCreation.MetricSelector.duration
        case .reps: return L10n.ExerciseCreation.MetricSelector.reps
        }
    }
    
    var image: Image {
        switch self {
        case .duration: return Image(systemName: "clock")
        case .reps: return Image(systemName: "number.circle")
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
