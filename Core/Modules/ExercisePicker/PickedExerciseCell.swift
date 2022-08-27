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
            Button {
                onRemoveTapped()
            } label: {
                Text(exercise.exerciseName)
                    .textStyle(.mediumButton)
                    .padding(.vertical, 12)
                    .padding(.horizontal)
            }
        }
        .background {
            Color.tertiaryBackground
                .cornerRadius(12)
        }
    }
}

struct PickedExerciseCell_Previews: PreviewProvider {
    static var previews: some View {
        PickedExerciseCell(
            exercise: .make(),
            onRemoveTapped: {}
        )
        .cellPreview()
        
        PickedExerciseCell(
            exercise: .make(),
            onRemoveTapped: {}
        )
        .cellPreview()
        .preferredColorScheme(.dark)
    }
}
