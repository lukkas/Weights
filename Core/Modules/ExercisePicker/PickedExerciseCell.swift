//
//  PickedExerciseCell.swift
//  Core
//
//  Created by Łukasz Kasperek on 01/12/2021.
//  Copyright © 2021 Łukasz Kasperek. All rights reserved.
//

import SwiftUI

struct PickedExerciseCell: View {
    let exercise: ExerciseCellViewModel
    let onRemoveTapped: () -> Void
    
    var body: some View {
        HStack(spacing: 0) {
            Text(exercise.exerciseName)
                .font(
                    .system(size: 16,
                            weight: .medium,
                            design: .rounded)
                )
                .padding(.vertical)
                .padding(.leading)
            Button {
                onRemoveTapped()
            } label: {
                Image(systemName: "xmark")
                    .font(
                        .system(size: 18,
                                weight: .semibold,
                                design: .rounded)
                    )
                    .tint(.red)
            }
            .frame(width: 40, height: 40)
            .padding(.trailing, 4)
        }
        .background {
            Color.background
                .cornerRadius(16)
        }
        .outerDepthShadow()
    }
}

struct PickedExerciseCell_Previews: PreviewProvider {
    static var previews: some View {
        PickedExerciseCell(
            exercise: .make(count: 1).first!,
            onRemoveTapped: {}
        )
            .cellPreview()
    }
}
