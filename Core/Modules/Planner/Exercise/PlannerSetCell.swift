//
//  PlannerSupersetCell.swift
//  Core
//
//  Created by Łukasz Kasperek on 11/09/2022.
//

import SwiftUI

struct PlannerSetsCellModel: Identifiable, Hashable {
    struct ExerciseSet: Identifiable, Hashable {
        let id: UUID = UUID()
        let metricLabel: String
        let metricFieldMode: ParameterFieldKind
        let weightLabel: String
        var metricValue: Double? = nil
        var weight: Double? = nil
    }
    
    let id: UUID = UUID()
    var numberOfSets: Double? = nil
    var exerciseSets: [ExerciseSet] = []
}

struct PlannerSetCell: View {
    @Binding var model: PlannerSetsCellModel
    
    var body: some View {
        HStack(spacing: 4) {
            PickerTextField(value: $model.numberOfSets)
                .fillColor(nil)
                .highlightColor(.label)
                .highlightStyle(.underline)
                .parameterField(.setsCount)
                .parameterFieldAligned()
            Text("sets")
            Spacer()
            VStack(spacing: 6) {
                ForEach($model.exerciseSets) { $exerciseSet in
                    HStack {
                        PickerTextField(value: $exerciseSet.metricValue)
                            .fillColor(.secondaryBackground)
                            .parameterField(exerciseSet.metricFieldMode)
                            .parameterFieldAligned()
                        Text(exerciseSet.metricLabel)
                        PickerTextField(value: $exerciseSet.weight)
                            .fillColor(.secondaryBackground)
                            .parameterField(.weight)
                            .parameterFieldAligned()
                        Text(exerciseSet.weightLabel)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(6)
                    .if(model.exerciseSets.count > 1, transform: { view in
                        view.overlay(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .stroke(
                                    Color.forSupersetIdentification(at: model.exerciseSets.firstIndex(of: exerciseSet)!)
                                )
                        )
                    })
                    .background(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .foregroundColor(.tertiaryBackground)
                    )
                }
            }
            .fixedSize(horizontal: true, vertical: false)
            .textStyle(.pickerAccessory)
        }
    }
}

struct PlannerSupersetCell_Previews: PreviewProvider {
    struct Wrapper: View {
        @State var model: PlannerSetsCellModel
        
        var body: some View {
            PlannerSetCell(model: $model)
        }
    }
    
    static var previews: some View {
        Wrapper(model: .dt_repsAndMins)
            .cellPreview()
    }
}

extension PlannerSetsCellModel {
    static var dt_repsAndMins: Self {
        PlannerSetsCellModel(
            exerciseSets: [
                .init(
                    metricLabel: "reps",
                    metricFieldMode: .reps,
                    weightLabel: "kg"
                ),
                .init(
                    metricLabel: "mins",
                    metricFieldMode: .time,
                    weightLabel: "kg"
                ),
            ]
        )
    }
    
    static var dt_reps: Self {
        PlannerSetsCellModel(
            exerciseSets: [
                .init(
                    metricLabel: "reps",
                    metricFieldMode: .reps,
                    weightLabel: "kg"
                )
            ]
        )
    }
}
