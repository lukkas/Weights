//
//  PlannerSetCell.swift
//  Core
//
//  Created by Łukasz Kasperek on 03/11/2020.
//  Copyright © 2020 Łukasz Kasperek. All rights reserved.
//

import SwiftUI

struct PlannerSetCellModel: Identifiable {
    enum Metric {
        case reps, time
    }
    
    let id = UUID()
    let metric: Metric
    
    var numerOfSets: Double?
    var reps: Double?
    var weight: Double?
}

private extension PlannerSetCellModel {
//    var 
}

struct PlannerSetCell: View {
    @Binding var model: PlannerSetCellModel
    
    var body: some View {
        HStack(alignment: .parameterFieldAlignment, spacing: 4) {
            ParameterField(
                themeColor: .repsMarker,
                kind: .setsCount,
                value: $model.numerOfSets
            )
                .alignmentGuide(
                    .repsAlignment,
                    computeValue: { $0[HorizontalAlignment.center]
                    }
                )
            Text("x")
                .font(.system(
                    size: 18,
                    weight: .semibold,
                    design: .rounded
                ))
                .alignmentGuide(.parameterFieldAlignment) { $0[VerticalAlignment.lastTextBaseline]
                }
            ParameterField(
                themeColor: .repsMarker,
                kind: .reps,
                value: $model.reps
            )
                .alignmentGuide(
                    .repsAlignment,
                    computeValue: { $0[HorizontalAlignment.center]
                    }
                )
            Text("reps")
                .font(.caption)
                .alignmentGuide(.parameterFieldAlignment) { $0[VerticalAlignment.lastTextBaseline]
                }
            ParameterField(
                themeColor: .weightMarker,
                kind: .weight,
                value: $model.weight
            )
                .alignmentGuide(.weightAlignment, computeValue: { d in
                    d[HorizontalAlignment.center]
                })
            Text("kg")
                .font(.caption)
                .alignmentGuide(.parameterFieldAlignment) { $0[VerticalAlignment.lastTextBaseline]
                }
            Spacer()
        }
        .background(Color.background)
    }
}

struct PlannerSetCell_Previews: PreviewProvider {
    struct Wrapper: View {
        @State var model = PlannerSetCellModel(metric: .reps)
        
        var body: some View {
            PlannerSetCell(model: $model)
        }
    }
    
    static var previews: some View {
        Wrapper()
            .cellPreview()
    }
}
