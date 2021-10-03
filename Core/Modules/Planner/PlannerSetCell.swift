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
        HStack(alignment: .parameterFieldAlignment) {
            ParameterField(
                label: L10n.Common.reps,
                themeColor: .repsMarker,
                value: $model.reps
            )
                .alignmentGuide(
                    .repsAlignment,
                    computeValue: { $0[HorizontalAlignment.center]
                    }
                )
            Text("x")
                .alignmentGuide(.parameterFieldAlignment) { $0[VerticalAlignment.center] }
            ParameterField(
                label: L10n.Common.kg,
                themeColor: .weightMarker,
                value: $model.weight
            )
                .alignmentGuide(.weightAlignment, computeValue: { d in
                    d[HorizontalAlignment.center]
                })
            Spacer()
            Button(
                action: {},
                label: {
                    Image(systemName: "plus")
                        .alignmentGuide(.parameterFieldAlignment) {
                            $0[VerticalAlignment.center]
                        }
                })
                .buttonStyle(.bordered)
                .controlSize(.regular)
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
