//
//  PlannerExerciseSupersetView.swift
//  Core
//
//  Created by Łukasz Kasperek on 04/09/2022.
//

import Foundation
import SwiftUI

struct PlannerExerciseView: View {
    enum Action {
        case addSet
        case addToSuperset
        case removeFromSuperset
    }
    
    @Binding var model: PlannerExercise
    let isAddToSupersetDisabled: Bool
    let isRemoveFromSupersetDisabled: Bool
    let onAction: (Action) -> Void
    
    var body: some View {
        VStack(spacing: 4) {
            VStack {
                HStack {
                    Text(model.name)
                    Spacer()
                    PacePicker(pace: $model.pace)
                }
            }
            .padding(8)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .foregroundColor(.secondaryBackground)
            )
            .padding(.bottom, 8)
            ForEach($model.sets) { $set in
                PlannerSetCell(model: $set)
            }
            HStack {
                Button {
                    withAnimation {
                        onAction(.addSet)
                    }
                } label: {
                    Text(L10n.Planner.Exercise.add)
                }
                .buttonStyle(.borderless)
                Spacer()
                Text(L10n.Planner.Exercise.supersets)
                Button {
                    onAction(.addToSuperset)
                } label: {
                    Image(systemName: "arrow.turn.left.up")
                }
                .disabled(isAddToSupersetDisabled)
                .buttonStyle(.borderedProminent)
                Button {
                    onAction(.removeFromSuperset)
                } label: {
                    Image(systemName: "arrow.turn.right.down")
                }
                .disabled(isRemoveFromSupersetDisabled)
                .buttonStyle(.bordered)
            }
            .padding(.vertical, 8)
            .textStyle(.mediumButton)
        }
        .padding(12)
        .cardDesign()
    }
}

// MARK: - Design time

#if DEBUG
struct PlannerExerciseView_Previews: PreviewProvider {
    struct Wrapper: View {
        @State var exercise = PlannerExercise.dt_squat()
        
        var body: some View {
            PlannerExerciseView(
                model: $exercise,
                isAddToSupersetDisabled: false,
                isRemoveFromSupersetDisabled: false,
                onAction: { _ in }
            )
        }
    }
    
    static var previews: some View {
        Wrapper()
            .cellPreview()
    }
}

#endif
