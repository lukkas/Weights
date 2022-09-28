//
//  PlannerSupersetCell.swift
//  Core
//
//  Created by Łukasz Kasperek on 11/09/2022.
//

import SwiftUI

struct PlannerSupersetCellModel: Identifiable, Hashable {
    struct SingleSet: Identifiable, Hashable {
        let id: UUID = UUID()
        let metricLabel: String
        let metricFieldMode: ParameterFieldKind
        let weightLabel: String
        var metricValue: Double? = nil
        var weight: Double? = nil
    }
    
    let id: UUID = UUID()
    var numberOfSets: Double? = nil
    var singleSets: [SingleSet] = []
}

struct PlannerSupersetCell: View {
    @Binding var model: PlannerSupersetCellModel
    
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
                ForEach($model.singleSets) { $singleSet in
                    HStack {
                        PickerTextField(value: $singleSet.metricValue)
                            .fillColor(.secondaryBackground)
                            .parameterField(singleSet.metricFieldMode)
                            .parameterFieldAligned()
                        Text(singleSet.metricLabel)
                        PickerTextField(value: $singleSet.weight)
                            .fillColor(.secondaryBackground)
                            .parameterField(.weight)
                            .parameterFieldAligned()
                        Text(singleSet.weightLabel)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(6)
                    .if(model.singleSets.count > 1, transform: { view in
                        view.overlay(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .stroke(
                                    Color.forSupersetIdentification(at: model.singleSets.firstIndex(of: singleSet)!)
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
            singleSets: [
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
}
