//
//  PlannerExerciseView.swift
//  Core
//
//  Created by Łukasz Kasperek on 11/10/2020.
//  Copyright © 2020 Łukasz Kasperek. All rights reserved.
//

import SwiftUI

struct PlannerExerciseView<Model: PlannerExerciseViewModeling>: View {
    @ObservedObject var model: Model
    
    var body: some View {
        VStack(spacing: 4) {
            HStack {
                Text(model.name)
                Spacer()
                PacePicker(pace: $model.pace)
            }
            .padding(8)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .foregroundColor(.secondaryBackground)
            )
            .padding(.bottom, 8)
            VStack(spacing: 4) {
                ForEach($model.variations) { variation in
                    PlannerSetCell(model: variation)
                }
            }
            .padding(8)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .foregroundColor(.secondaryBackground)
            )
            .padding(.bottom, 8)
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

protocol PlannerExerciseViewModeling: ObservableObject, Identifiable, Hashable {
    var name: String { get }
    var pace: UIPacePicker.InputState { get set }
    var variations: [PlannerSetCellModel] { get set }
    func addVariationTapped()
}

extension PlannerExerciseViewModeling {
    static func == (lhs: Self, rhs: Self) -> Bool {
        return
            lhs.id == rhs.id
            && lhs.name == rhs.name
            && lhs.variations == rhs.variations
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(variations)
    }
}

// MARK: - Design time

class DTPlannerExerciseViewModel: PlannerExerciseViewModeling {
    init() {
        
    }
    
    let name: String = "Squat"
    @Published var pace = UIPacePicker.InputState()
    @Published var variations: [PlannerSetCellModel] = [.dt_reps]
    
    func addVariationTapped() {
        variations.append(.dt_reps)
    }
}

struct PlannerExerciseView_Previews: PreviewProvider {
    static var previews: some View {
        PlannerExerciseView(model: DTPlannerExerciseViewModel())
            .cellPreview()
    }
}
