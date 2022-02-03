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
    @StateObject var model: Model
    @Binding var isPresented: Bool
    
    var body: some View {
        NavigationView {
            Form {
                TextField(L10n.ExerciseCreation.NameField.title, text: $model.name)
                Section(
                    header: Text(
                        verbatim: L10n.ExerciseCreation.MetricSelector.title
                    )
                        .font(.headline),
                    footer: Text(
                        verbatim: L10n.ExerciseCreation.MetricSelector.comment
                    )
                ) {
                    optionButton(metric: .reps)
                    optionButton(metric: .duration)
                }
                Section(
                    header: Text(verbatim: L10n.ExerciseCreation.LateralitySelector.title)
                        .font(.headline),
                    footer: Text(verbatim: L10n.ExerciseCreation.LateralitySelector.comment)
                ) {
                    optionButton(laterality: .bilateral)
                    optionButton(laterality: .unilateralSingle)
                    optionButton(laterality: .unilateralIndividual)
                }
            }
            .navigationBarItems(
                leading: Button(L10n.Common.cancel, action: {
                    isPresented = false
                }),
                trailing: Button(action: {
                    model.handleAddTapped()
                }, label: {
                    if model.isProcessing {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                    } else {
                        Text(L10n.ExerciseCreation.add)
                    }
                })
                    .disabled(!model.isAddButtonActive)
            ).navigationBarTitle(L10n.ExerciseCreation.title, displayMode: .inline)
        }
        .onReceive(model.didAddExercise, perform: { _ in
            isPresented = false
        })
    }
    
    @ViewBuilder private func optionButton(
        metric: Exercise.Metric
    ) -> some View {
        Button(action: { model.metric = metric }, label: {
            HStack {
                Image(systemName: metric.imageName)
                    .foregroundColor(
                        model.metric == metric ? .accentColor : .label
                    )
                Text(metric.title)
                    .foregroundColor(
                        model.metric == metric ? .accentColor : .label
                    )
                if model.metric == metric {
                    Spacer()
                    Image(systemName: "checkmark")
                        .foregroundColor(.accentColor)
                }
            }
        })
    }
    
    @ViewBuilder private func optionButton(
        laterality: Exercise.Laterality
    ) -> some View {
        Button(action: { model.laterality = laterality }, label: {
            HStack {
                Text(laterality.title)
                    .foregroundColor(
                        model.laterality == laterality ? .accentColor : .label
                    )
                if model.laterality == laterality {
                    Spacer()
                    Image(systemName: "checkmark")
                        .foregroundColor(.accentColor)
                }
            }
        })
    }
}

private extension Exercise.Metric {
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

private extension Exercise.Laterality {
    var title: String {
        switch self {
        case .bilateral:
            return L10n.ExerciseCreation.LateralitySelector.bilateral
        case .unilateralSingle:
            return L10n.ExerciseCreation.LateralitySelector.unilateralSingle
        case .unilateralIndividual:
            return L10n.ExerciseCreation.LateralitySelector.unilateralIndividual
        }
    }
}

class ExerciseCreationPreviewModel: ExerciseCreationViewModeling {
    @Published var name: String = ""
    @Published var metric: Exercise.Metric? = nil
    @Published var laterality: Exercise.Laterality? = nil
    @Published var isAddButtonActive: Bool = true
    @Published var isProcessing = false
    var didAddExercise: AnyPublisher<Void, Never> {
        PassthroughSubject<Void, Never>().eraseToAnyPublisher()
    }
    
    func handleAddTapped() {
        isProcessing.toggle()
    }
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
