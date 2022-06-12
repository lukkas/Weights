//
//  PlannerSetCell.swift
//  Core
//
//  Created by Łukasz Kasperek on 03/11/2020.
//  Copyright © 2020 Łukasz Kasperek. All rights reserved.
//

import SwiftUI

struct PlannerSetCellModel: Equatable, Identifiable, Hashable, Codable {
    let id: UUID
    let metric: Exercise.Metric
    
    var numberOfSets: Double?
    var metricValue: Double?
    var weight: Double?
    
    init(
        metric: Exercise.Metric,
        numerOfSets: Double? = nil,
        metricValue: Double? = nil,
        weight: Double? = nil
    ) {
        self.id = UUID()
        self.metric = metric
        self.numberOfSets = numerOfSets
        self.metricValue = metricValue
        self.weight = weight
    }
}

struct PlannerSetCell: View {
    @Binding var model: PlannerSetCellModel
    
    var body: some View {
        HStack(spacing: 4) {
            PickerTextField(value: $model.numberOfSets)
                .fillColor(.background)
                .borderColor(.label)
                .parameterField(.setsCount)
                .parameterFieldAligned()
            Text("x")
                .font(.system(
                    size: 18,
                    weight: .semibold,
                    design: .rounded
                ))
            HStack {
                Image(systemName: "clock.arrow.circlepath")
                PickerTextField(value: $model.metricValue)
                    .parameterField(model.metric.parameterFieldMode)
                    .parameterFieldAligned()
                Image(systemName: "scalemass")
                PickerTextField(value: $model.weight)
                    .parameterField(.weight)
                    .parameterFieldAligned()
            }
            .padding(4)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .foregroundColor(.secondaryBackground)
            )
            Spacer()
        }
        .background(Color.background)
    }
}

struct PlannerSetCell_Previews: PreviewProvider {
    struct Wrapper: View {
        @State var model: PlannerSetCellModel
        
        init(metric: Exercise.Metric) {
            _model = State(initialValue: PlannerSetCellModel(metric: metric))
        }
        
        var body: some View {
            PlannerSetCell(model: $model)
        }
    }
    
    static var previews: some View {
        Wrapper(metric: .reps)
            .cellPreview()
        
        Wrapper(metric: .duration)
            .cellPreview()
    }
}
