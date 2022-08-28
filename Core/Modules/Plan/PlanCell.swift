//
//  PlanCell.swift
//  Core
//
//  Created by Łukasz Kasperek on 24/08/2022.
//

import Foundation
import SwiftUI

struct PlanCellModel {
    let name: String
    let days: [String]
}

struct PlanCell: View {
    let model: PlanCellModel
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(model.name)
                    .textStyle(.largeSectionTitle)
                Spacer()
                Button {
                    
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .textStyle(.largeIconButton)
                        .tint(.label)
                }
            }
            HStack {
                ForEach(model.days, id: \.self) { day in
                    Text(day)
                    if day != model.days.last {
                        Text("|")
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(8)
            .background(
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .foregroundColor(.secondaryBackground)
            )
            Text("Last performed: 12.03.2022 - 21.04.2022")
        }
        .padding()
    }
}

struct PlanCell_Previews: PreviewProvider {
    static var previews: some View {
        PlanCell(model: model)
            .cardPreview()
    }
    
    private static var model: PlanCellModel {
        return PlanCellModel(
            name: "Push - pull - legs",
            days: ["Push", "Pull", "Legs", "FBW"]
        )
    }
}
