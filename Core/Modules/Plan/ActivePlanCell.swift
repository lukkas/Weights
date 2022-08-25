//
//  ActivePlanCell.swift
//  Core
//
//  Created by Łukasz Kasperek on 24/08/2022.
//

import Foundation
import SwiftUI

struct ActivePlanCellModel {
    struct Day: Identifiable {
        let id: UUID
        let name: String
        let isUpcoming: Bool
    }
    let name: String
    let days: [Day]
}

struct ActivePlanCell: View {
    let model: ActivePlanCellModel
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(model.name)
                    .font(.system(size: 24, weight: .semibold, design: .rounded))
                HStack {
                    VStack {
                        ForEach(model.days) { day in
                            Text(day.name)
                        }
                    }
                    .font(.system(size: 18, weight: .medium, design: .rounded))
                    Spacer()
                    Button {
                        
                    } label: {
                        Text("Start")
                            .frame(minWidth: 60, minHeight: 44)
                    }
                    .tint(Color.green)
                    .buttonStyle(.borderedProminent)
                }
            }
        }
    }
}

struct ActivePlanCell_Previews: PreviewProvider {
    static var previews: some View {
        ActivePlanCell(model: model)
            .cellPreview()
    }
    
    private static var model: ActivePlanCellModel {
        return ActivePlanCellModel(
            name: "Upper - Lower",
            days: [
                .init(id: .init(), name: "A1", isUpcoming: false),
                .init(id: .init(), name: "B1", isUpcoming: true),
                .init(id: .init(), name: "A2", isUpcoming: false),
                .init(id: .init(), name: "B2", isUpcoming: false)
            ]
        )
    }
}
