//
//  PlannerSupersetCell.swift
//  Core
//
//  Created by Łukasz Kasperek on 11/09/2022.
//

import SwiftUI

struct PlannerSupersetCellModel: Identifiable, Hashable {
    struct Exercise: Identifiable, Hashable {
        let id: UUID = UUID()
        let metricLabel: String
        let metricFieldMode: ParameterFieldKind
        let weightLabel: String
        let highlightColor: Color
        var metricValue: Double? = nil
        var weight: Double? = nil
    }
    
    let id: UUID = UUID()
    var numberOfSets: Double? = nil
    var exercises: [Exercise] = []
}

struct PlannerSupersetCell: View {
    @Binding var model: PlannerSupersetCellModel
    
    var body: some View {
        HStack(spacing: 4) {
            PickerTextField(value: $model.numberOfSets)
                .fillColor(.background)
                .borderColor(.label)
                .parameterField(.setsCount)
                .parameterFieldAligned()
            Text("x")
                .textStyle(.pickerField)
            VStack(spacing: 0) {
                ForEach($model.exercises) { $exercise in
                    HStack {
                        PickerTextField(value: $exercise.metricValue)
                            .fillColor(Color(white: 0.9))
                            .parameterField(exercise.metricFieldMode)
                            .parameterFieldAligned()
                        Text(exercise.metricLabel)
                        PickerTextField(value: $exercise.weight)
                            .fillColor(Color(white: 0.9))
                            .parameterField(.weight)
                            .parameterFieldAligned()
                        Text(exercise.weightLabel)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(6)
                    .background(
                        exercise.highlightColor
                    )
                }
            }
            .fixedSize(horizontal: true, vertical: false)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .textStyle(.pickerAccessory)
            Spacer()
        }
        .background(Color.background)
    }
}

struct PlannerSupersetCell_Previews: PreviewProvider {
    struct Wrapper: View {
        @State var model: PlannerSupersetCellModel
        
        var body: some View {
            PlannerSupersetCell(model: $model)
        }
    }
    
    static var previews: some View {
        Wrapper(model: .dt_repsAndMins)
            .cellPreview()
    }
}

extension PlannerSupersetCellModel {
    static var dt_repsAndMins: Self {
        PlannerSupersetCellModel(
            exercises: [
                .init(
                    metricLabel: "reps",
                    metricFieldMode: .reps,
                    weightLabel: "kg",
                    highlightColor: .weightRed.opacity(0.35)
                ),
                .init(
                    metricLabel: "mins",
                    metricFieldMode: .time,
                    weightLabel: "kg",
                    highlightColor: .weightGreen.opacity(0.35)
                ),
            ]
        )
    }
}
