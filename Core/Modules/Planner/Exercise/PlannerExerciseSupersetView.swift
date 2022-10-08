//
//  PlannerExerciseSupersetView.swift
//  Core
//
//  Created by Łukasz Kasperek on 04/09/2022.
//

import Foundation
import SwiftUI

struct PlannerExerciseSupersetView: View {
    @ObservedObject var model: PlannerExerciseSupersetViewModel
    
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
                PlannerSupersetCell(model: variation)
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

struct PlannerExerciseHeaderRow: Hashable, Identifiable {
    let id = UUID()
    let name: String
    var pace: UIPacePicker.InputState
}

// MARK: - Design time

#if DEBUG
struct PlannerExerciseSupersetView_Previews: PreviewProvider {
    static var previews: some View {
        PlannerExerciseSupersetView(model: .dt_squatDeadlift())
            .cellPreview()
    }
}

extension PlannerExerciseSupersetViewModel {
    static func dt_squatDeadlift() -> PlannerExerciseSupersetViewModel {
        return PlannerExerciseSupersetViewModel(
            headerRows: [
                PlannerExerciseHeaderRow(
                    name: "Squat",
                    pace: UIPacePicker.InputState()
                ),
                PlannerExerciseHeaderRow(
                    name: "Deadlift",
                    pace: UIPacePicker.InputState()
                )
            ],
            variations: [.dt_repsAndMins],
            onAddVarationTap: {}
        )
    }
}
#endif
