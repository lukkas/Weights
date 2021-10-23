//
//  PlannerSetCell.swift
//  Core
//
//  Created by Łukasz Kasperek on 03/11/2020.
//  Copyright © 2020 Łukasz Kasperek. All rights reserved.
//

import SwiftUI

protocol PlannerSetCellModeling: ObservableObject {
    var reps: Double? { get set }
    var weight: Double? { get set }
}

struct PlannerSetCell<Model: PlannerSetCellModeling>: View {
    @Binding var model: Model
    
    var body: some View {
        HStack(alignment: .parameterFieldAlignment, spacing: 4) {
            ParameterField(
                themeColor: .repsMarker,
                value: $model.reps
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
    class Model: PlannerSetCellModeling {
        @Published var reps: Double? = 0
        @Published var weight: Double? = 0
    }
    
    struct Wrapper: View {
        @State var model = Model()
        
        var body: some View {
            PlannerSetCell(model: $model)
        }
    }
    
    static var previews: some View {
        Wrapper()
            .cellPreview()
    }
}
