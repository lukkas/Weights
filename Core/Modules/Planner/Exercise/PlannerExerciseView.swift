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
        case removeSet(PlannerExercise.Set)
        case addToSuperset
        case removeFromSuperset
    }
    
    @Binding var model: PlannerExercise
    @StateObject private var repsBatchEditor = ExerciseBatchEditor()
    @StateObject private var weightBatchEditor = ExerciseBatchEditor()
    let isAddToSupersetDisabled: Bool
    let isRemoveFromSupersetDisabled: Bool
    let onAction: (Action) -> Void
    
    var body: some View {
//        TextField("", text: .constant("")) { editingChanged in
//            
//        } onCommit: {
//            
//        }
//        .focus

        VStack(spacing: 0) {
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
                let index = model.sets.firstIndex(of: set)!
                PlannerSetCell(
                    model: $set,
                    repsBatchEditor: repsBatchEditor,
                    weightBatchEditor: weightBatchEditor,
                    setIndex: index
                ) { action in
                    switch action {
                    case .remove:
                        onAction(.removeSet(set))
                    }
                }
            }
            .onDelete { indexSet in
                for index in indexSet {
                    onAction(.removeSet(model.sets[index]))
                }
            }
            HStack {
                Button {
                    withAnimation {
                        onAction(.addSet)
                    }
                } label: {
                    Text(L10n.Planner.Exercise.addSet)
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
