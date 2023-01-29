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
    }
    
    @Binding var model: PlannerExercise
    @StateObject private var repsBatchEditor: ExerciseBatchEditor
    @StateObject private var weightBatchEditor: ExerciseBatchEditor
    let isAddToSupersetDisabled: Bool
    let isRemoveFromSupersetDisabled: Bool
    let onAction: (Action) -> Void
    
    init(
        model: Binding<PlannerExercise>,
        isAddToSupersetDisabled: Bool,
        isRemoveFromSupersetDisabled: Bool,
        onAction: @escaping (Action) -> Void
    ) {
        _model = model
        let repsBinding = Binding<[Double?]>(
            get: { model.wrappedValue.sets.map(\.repCount) },
            set: { values in
                for index in model.wrappedValue.sets.indices {
                    model.wrappedValue.sets[index].repCount = values[index]
                }
            }
        )
        let weightBinding = Binding<[Double?]>(
            get: { model.wrappedValue.sets.map(\.weight) },
            set: { values in
                for index in model.wrappedValue.sets.indices {
                    model.wrappedValue.sets[index].weight = values[index]
                }
            }
        )
        _repsBatchEditor = StateObject(
            wrappedValue: ExerciseBatchEditor(sets: repsBinding)
        )
        _weightBatchEditor = StateObject(
            wrappedValue: ExerciseBatchEditor(sets: weightBinding)
        )
        self.isAddToSupersetDisabled = isAddToSupersetDisabled
        self.isRemoveFromSupersetDisabled = isRemoveFromSupersetDisabled
        self.onAction = onAction
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text(model.name)
                    .padding(.leading, .grid(1))
                Spacer()
                PacePicker(pace: $model.pace)
            }
            .textStyle(.sectionTitle)
            .padding(.bottom, 8)
            ForEach($model.sets) { $set in
                let index = model.sets.firstIndex(of: set)!
                PlannerSetCell(
                    model: $model.sets[index],
                    repsBatchEditor: repsBatchEditor,
                    weightBatchEditor: weightBatchEditor,
                    setIndex: index
                )
            }
            HStack {
                Button {
                    withAnimation {
                        onAction(.addSet)
                    }
                } label: {
                    Image(systemName: "plus")
                }
                .buttonStyle(.borderedProminent)
                Button {
                    guard let set = model.sets.last else { return }
                    withAnimation {
                        onAction(.removeSet(set))
                    }
                } label: {
                    Image(systemName: "minus")
                        .frame(maxHeight: .infinity)
                }
                .buttonStyle(.bordered)
                
                Spacer()
            }
            .fixedSize(horizontal: false, vertical: true)
            .padding(.vertical, 8)
            .textStyle(.mediumButton)
        }
        .padding(12)
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
                onAction: { action in
                    switch action {
                    case .addSet:
                        exercise.sets.append(.dt_reps)
                    case let .removeSet(set):
                        exercise.sets.remove(at: exercise.sets.firstIndex(of: set)!)
                    }
                }
            )
        }
    }
    
    static var previews: some View {
        Wrapper()
            .cellPreview()
    }
}

#endif
