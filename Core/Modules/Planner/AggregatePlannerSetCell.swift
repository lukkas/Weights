//
//  AggregatePlannerSetCell.swift
//  AggregatePlannerSetCell
//
//  Created by Łukasz Kasperek on 08/08/2021.
//  Copyright © 2021 Łukasz Kasperek. All rights reserved.
//

import SwiftUI

protocol AggregatePlannerSetCellModeling: ObservableObject {
    var numberOfSets: Int { get }
    var reps: Double { get }
    var weight: Double { get }
    
    func handleRemoveSetTapped()
}

struct AggregatePlannerSetCell<Model: AggregatePlannerSetCellModeling>: View {
    @Binding var model: Model
    
    var body: some View {
        HStack(alignment: .parameterFieldAlignment, spacing: 4) {
            Text(String(model.numberOfSets))
                .font(.system(
                    size: 18,
                    weight: .semibold,
                    design: .rounded
                ))
                .alignmentGuide(.parameterFieldAlignment) { $0[VerticalAlignment.lastTextBaseline] }
            Text("x")
                .alignmentGuide(.parameterFieldAlignment) { $0[VerticalAlignment.lastTextBaseline] }
            
            FrozenParameterField(
                label: L10n.Common.reps,
                value: String(model.reps),
                themeColor: .repsMarker
            )
                .alignmentGuide(.repsAlignment, computeValue: { d in
                    d[HorizontalAlignment.center]
                })
            Text("reps")
                .font(.caption)
                .alignmentGuide(.parameterFieldAlignment) { $0[VerticalAlignment.lastTextBaseline]
                }
            FrozenParameterField(
                label: L10n.Common.kg,
                value: String(model.weight),
                themeColor: .weightMarker
            )
                .alignmentGuide(.weightAlignment, computeValue: { d in
                    d[HorizontalAlignment.center]
                })
            Text("kg")
                .font(.caption)
                .alignmentGuide(.parameterFieldAlignment) { $0[VerticalAlignment.lastTextBaseline]
                }
            Spacer()
            Button(
                action: {
                    model.handleRemoveSetTapped()
                },
                label: {
                    Image(systemName: "minus")
                        .font(.system(
                            size: 14,
                            weight: .semibold,
                            design: .rounded
                        ))
                        .frame(minHeight: 24)
                        .alignmentGuide(.parameterFieldAlignment) {
                            $0[VerticalAlignment.lastTextBaseline]
                        }
                })
                .frame(minHeight: 36)
                .tint(.red)
                .buttonStyle(.bordered)
                .controlSize(.regular)
        }
        .background(Color.background)
    }
}

struct AggregatePlannerSetCell_Previews: PreviewProvider {
    class Model: AggregatePlannerSetCellModeling {
        var numberOfSets: Int = 2
        var reps: Double = 5
        var weight: Double = 190
        
        func handleRemoveSetTapped() {}
    }
    
    struct Wrapper: View {
        @State var model = Model()
        
        var body: some View {
            AggregatePlannerSetCell(model: $model)
        }
    }
    
    static var previews: some View {
        Wrapper()
            .cellPreview()
    }
}
