//
//  PlannerExerciseSupersetView.swift
//  Core
//
//  Created by Łukasz Kasperek on 04/09/2022.
//

import Foundation
import SwiftUI

struct PlannerExerciseView: View {
    @ObservedObject var model: PlannerExerciseViewModel
    
    var body: some View {
        VStack(spacing: 4) {
            VStack {
                ForEach($model.headerRows) { $row in
                    HStack {
                        Text(row.name)
                            .if(model.headerRows.count > 1, transform: { view in
                                view.foregroundColor(.forSupersetIdentification(at: model.headerRows.firstIndex(of: row)!))
                            })
                        Spacer()
                        PacePicker(pace: $row.pace)
                    }
                }
            }
            .padding(8)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .foregroundColor(.secondaryBackground)
            )
            .padding(.bottom, 8)
            ForEach($model.variations) { variation in
                PlannerSetCell(model: variation)
                    .padding(8)
                    .background(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .foregroundColor(.secondaryBackground)
                    )
                    .padding(.bottom, 8)
            }
            HStack {
                Button {
                    withAnimation {
                        model.addVariationTapped()
                    }
                } label: {
                    Text(L10n.Planner.Exercise.add)
                }
                .buttonStyle(.borderless)
                Spacer()
                Text(L10n.Planner.Exercise.supersets)
                Button {
                    model.addToSuperset()
                } label: {
                    Image(systemName: "arrow.turn.left.up")
                }
                .disabled(!model.supersetAddEnabled)
                .buttonStyle(.borderedProminent)
                Button {
                    model.removeFromSuperset()
                } label: {
                    Image(systemName: "arrow.turn.right.down")
                }
                .disabled(!model.supersetRemoveEnabled)
                .buttonStyle(.bordered)
            }
            .padding(.vertical, 8)
            .textStyle(.mediumButton)
        }
        .padding(12)
        .cardDesign()
    }
}

struct PlannerExerciseHeaderRow: Hashable, Identifiable {
    let id = UUID()
    let exerciseId: UUID
    let name: String
    var pace = UIPacePicker.InputState()
}

// MARK: - Design time

#if DEBUG
struct PlannerExerciseSupersetView_Previews: PreviewProvider {
    static var previews: some View {
        PlannerExerciseView(model: .dt_squatDeadlift())
            .cellPreview()
            .previewDisplayName("Superset")
        
        PlannerExerciseView(model: .dt_squat())
            .cellPreview()
            .previewDisplayName("Single set")
    }
}

extension PlannerExerciseViewModel {
    static func dt_squatDeadlift() -> PlannerExerciseViewModel {
        return PlannerExerciseViewModel(
            headerRows: [
                PlannerExerciseHeaderRow(
                    exerciseId: UUID(),
                    name: "Squat",
                    pace: UIPacePicker.InputState()
                ),
                PlannerExerciseHeaderRow(
                    exerciseId: UUID(),
                    name: "Deadlift",
                    pace: UIPacePicker.InputState()
                )
            ],
            variations: [.dt_repsAndMins],
            onAddVarationTap: {},
            onSupersetAction: { _ in },
            onVariationsChanged: { _ in }
        )
    }
    
    static func dt_squat() -> PlannerExerciseViewModel {
        return PlannerExerciseViewModel(
            headerRows: [
                PlannerExerciseHeaderRow(
                    exerciseId: UUID(),
                    name: "Squat",
                    pace: UIPacePicker.InputState()
                )
            ],
            variations: [.dt_reps],
            onAddVarationTap: {},
            onSupersetAction: { _ in },
            onVariationsChanged: { _ in }
        )
    }
}
#endif
