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
        let state: DayState
    }
    let name: String
    let days: [Day]
    let selectedDayDescription: [AttributedString]
    let schedulingInfo: AttributedString
}

struct ActivePlanCell: View {
    let model: ActivePlanCellModel
    
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
                HStack {
                    ForEach(model.days) { day in
                        Button {
                            
                        } label: {
                            Text(day.name)
                                .foregroundColor(dayLabelColor(for: day.state))
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(
                                    RoundedRectangle(cornerRadius: 4, style: .continuous)
                                        .foregroundColor(dayForegroundColor(for: day.state))
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
            Text(model.schedulingInfo)
        }
        .padding(16)
    }
    
    private func dayLabelColor(for status: ActivePlanCellModel.DayState) -> Color {
        switch status {
        case .regular: return .accentColor
        case .selected, .upcoming: return .contrastLabel
        }
    }
    
    private func dayForegroundColor(for status: ActivePlanCellModel.DayState) -> Color {
        switch status {
        case .regular: return .secondaryBackground
        case .selected: return .accentColor
        case .upcoming: return Color.accentColor.opacity(0.5)
        }
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
                .init(id: .init(), name: "A1", state: .regular),
                .init(id: .init(), name: "B1", state: .selected),
                .init(id: .init(), name: "A2", state: .upcoming),
                .init(id: .init(), name: "B2", state: .regular)
            ],
            selectedDayDescription: [
                try! AttributedString(markdown: "**B1** (approx. in 3 days)"),
                "4x Squat",
                "3x Deadlift",
                "3x Hip thrust",
                "Last performed: 4 days ago"
            ],
            schedulingInfo: try! AttributedString(
                markdown: "**Started:** 23rd of July\n3 cycles completed",
                options: AttributedString.MarkdownParsingOptions(interpretedSyntax: .inlineOnlyPreservingWhitespace)
            )
        )
    }
}
