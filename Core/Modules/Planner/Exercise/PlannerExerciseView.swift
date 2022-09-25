//
//  PlannerExerciseView.swift
//  Core
//
//  Created by Łukasz Kasperek on 11/10/2020.
//  Copyright © 2020 Łukasz Kasperek. All rights reserved.
//

import SwiftUI

struct PlannerExerciseView: View {
    @ObservedObject var model: PlannerExerciseViewModel
    
    var body: some View {
        VStack(spacing: 4) {
            HStack {
                Text(model.name)
                Spacer()
                PacePicker(pace: $model.pace)
            }
            .padding(8)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .foregroundColor(.secondaryBackground)
            )
            .padding(.bottom, 8)
            VStack(spacing: 4) {
                ForEach($model.variations) { variation in
                    PlannerSetCell(model: variation)
                }
            }
            .padding(8)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .foregroundColor(.secondaryBackground)
            )
            .padding(.bottom, 8)
            HStack {
                Button {
                    withAnimation {
                        model.addVariationTapped()
                    }
                } label: {
                    Text(L10n.Planner.Exercise.add)
                        .textStyle(.mediumButton)
                        .padding(.vertical, 8)
                }
                .buttonStyle(.borderless)
                
                Spacer()
            }
        }
        .padding(12)
        .cardDesign()
    }
}

// MARK: - Design time

#if DEBUG
struct PlannerExerciseView_Previews: PreviewProvider {
    static var previews: some View {
        PlannerExerciseView(model: PlannerExerciseViewModel.dt_squat)
            .cellPreview()
    }
}

extension PlannerExerciseViewModel {
    static var dt_squat: PlannerExerciseViewModel {
        weak var weakModel: PlannerExerciseViewModel?
        let model = PlannerExerciseViewModel(
            exerciseId: UUID(),
            exerciseName: "Squat",
            setVariations: [.dt_reps],
            onAddVarationTap: {
                weakModel?.variations.append(.dt_reps)
            },
            onVariationsChanged: { _ in }
        )
        weakModel = model
        return model
    }
}
#endif
