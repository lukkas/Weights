//
//  ActivePlanCell.swift
//  Core
//
//  Created by Łukasz Kasperek on 24/08/2022.
//

import Foundation
import SwiftUI

struct ActivePlanCellModel {
    enum DayState {
        case selected
        case upcoming
        case regular
    }
    
    struct Day: Identifiable {
        let id: UUID
        let name: String
        let isUpcoming: Bool
    }
    let name: String
    let days: [Day]
    let selectedDayDescription: [AttributedString]
}

struct ActivePlanCell: View {
    let model: ActivePlanCellModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(model.name)
                .textStyle(.largeSectionTitle)
            HStack {
                HStack {
                    ForEach(model.days) { day in
                        Button {
                            
                        } label: {
                            Text(day.name)
                                .foregroundColor(
                                    day.isUpcoming
                                    ? .contrastLabel
                                    : .accentColor
                                )
                                .padding(4)
                                .background(
                                    RoundedRectangle(cornerRadius: 4, style: .continuous)
                                        .foregroundColor(
                                            day.isUpcoming
                                            ? .accentColor
                                            : .secondaryBackground
                                        )
                                )
                        }
                        if day.id != model.days.last?.id {
                            Text("|")
                        }
                    }
                }
                .font(.system(size: 18, weight: .medium, design: .rounded))
                Spacer()
                Button {
                    
                } label: {
                    Text("Start")
                        .textStyle(.largeButton)
                        .frame(minWidth: 60, minHeight: 44)
                }
                .tint(Color.green)
                .buttonStyle(.borderedProminent)
            }
            VStack(alignment: .leading) {
                ForEach(model.selectedDayDescription, id: \.self) { descriptionLine in
                    Text(descriptionLine)
                }
            }
            .padding(8)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .foregroundColor(.secondaryBackground)
            )
        }
        .padding(16)
    }
}

struct ActivePlanCell_Previews: PreviewProvider {
    static var previews: some View {
        ActivePlanCell(model: model)
            .cardPreview()
    }
    
    private static var model: ActivePlanCellModel {
        return ActivePlanCellModel(
            name: "Upper - Lower",
            days: [
                .init(id: .init(), name: "A1", isUpcoming: false),
                .init(id: .init(), name: "B1", isUpcoming: true),
                .init(id: .init(), name: "A2", isUpcoming: false),
                .init(id: .init(), name: "B2", isUpcoming: false)
            ],
            selectedDayDescription: [
                try! AttributedString(markdown: "**B1** (upcoming)"),
                "4x Squat",
                "3x Deadlift",
                "3x Hip thrust"
            ]
        )
    }
}
