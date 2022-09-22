//
//  PlannerSetCell.swift
//  Core
//
//  Created by Łukasz Kasperek on 03/11/2020.
//  Copyright © 2020 Łukasz Kasperek. All rights reserved.
//

import SwiftUI

struct PlannerSetCellModel: Identifiable, Hashable {
    let id: UUID = UUID()
    let metricLabel: String
    let metricFieldMode: ParameterFieldKind
    let weightLabel: String
    
    var numberOfSets: Double? = nil
    var metricValue: Double? = nil
    var weight: Double? = nil
}

struct PlannerSetCell: View {
    @Binding var model: PlannerSetCellModel
    
    var body: some View {
        HStack(spacing: 4) {
            PickerTextField(value: $model.numberOfSets)
                .fillColor(.background)
                .highlightStyle(.underline)
                .highlightColor(.label)
                .parameterField(.setsCount)
                .parameterFieldAligned()
            Text("sets")
                .textStyle(.pickerField)
            Spacer()
            HStack {
                PickerTextField(value: $model.metricValue)
                    .parameterField(model.metricFieldMode)
                    .parameterFieldAligned()
                Text(model.metricLabel)
                PickerTextField(value: $model.weight)
                    .parameterField(.weight)
                    .parameterFieldAligned()
                Text(model.weightLabel)
            }
            .textStyle(.pickerAccessory)
            .padding(4)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .foregroundColor(.secondaryBackground)
            )
        }
        .background(Color.background)
    }
}

struct PlannerSetCell_Previews: PreviewProvider {
    struct Wrapper: View {
        @State var model: PlannerSetCellModel
        
        var body: some View {
            PlannerSetCell(model: $model)
        }
    }
    
    static var previews: some View {
        Wrapper(model: .dt_reps)
            .cellPreview()
        
        Wrapper(model: .dt_duration)
            .cellPreview()
    }
}

extension PlannerSetCellModel {
    static var dt_reps: PlannerSetCellModel {
        PlannerSetCellModel(
            metricLabel: "reps",
            metricFieldMode: .reps,
            weightLabel: "kg"
        )
    }
    
    static var dt_duration: PlannerSetCellModel {
        PlannerSetCellModel(
            metricLabel: "mins",
            metricFieldMode: .time,
            weightLabel: "kg"
        )
    }
}
