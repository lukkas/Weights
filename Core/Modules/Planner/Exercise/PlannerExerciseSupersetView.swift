//
//  PlannerExerciseSupersetView.swift
//  Core
//
//  Created by Łukasz Kasperek on 04/09/2022.
//

import Foundation
import SwiftUI

struct PlannerExerciseSupersetView<Model: PlannerExerciseSupersetViewModeling>: View {
    @ObservedObject var model: Model
    
    var body: some View {
        VStack(spacing: 4) {
            HStack {
                Text(model.headerRow.name)
                Spacer()
                PacePicker(pace: $model.headerRow.pace)
            }
            Divider()
            ForEach($model.variations) { variation in
                PlannerSetCell(model: variation)
            }
            HStack {
                Button {
                    withAnimation {
                        model.addVariationTapped()
                    }
                } label: {
                    Text(L10n.Planner.Exercise.add)
                        .textStyle(.mediumButton)
                        .padding(.vertical, 8)
                }
                .buttonStyle(.borderless)
                
                Spacer()
            }
        }
        .padding(12)
        .cardDesign()
    }
}

struct PlannerExerciseHeaderRow: Hashable {
    let name: String
    var pace: UIPacePicker.InputState
}

protocol PlannerExerciseSupersetViewModeling: ObservableObject, Identifiable, Hashable {
    var headerRow: PlannerExerciseHeaderRow { get set }
    var variations: [PlannerSetCellModel] { get set }
    func addVariationTapped()
}

extension PlannerExerciseSupersetViewModeling {
    static func == (lhs: Self, rhs: Self) -> Bool {
        return
            lhs.id == rhs.id
            && lhs.headerRow == rhs.headerRow
            && lhs.variations == rhs.variations
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(headerRow)
        hasher.combine(variations)
    }
}

// MARK: - Design time

class DTPlannerExerciseSupersetViewModel: PlannerExerciseSupersetViewModeling {
    init() {
        
    }
    
    @Published var headerRow = PlannerExerciseHeaderRow(
        name: "Squat",
        pace: UIPacePicker.InputState()
    )
    @Published var variations: [PlannerSetCellModel] = [.dt_reps]
    
    func addVariationTapped() {
        variations.append(.dt_reps)
    }
}

struct PlannerExerciseSupersetView_Previews: PreviewProvider {
    static var previews: some View {
        PlannerExerciseSupersetView(model: DTPlannerExerciseSupersetViewModel())
            .cellPreview()
    }
}
