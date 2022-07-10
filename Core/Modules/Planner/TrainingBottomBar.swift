//
//  TrainingBottomBar.swift
//  Core
//
//  Created by Łukasz Kasperek on 11/11/2021.
//  Copyright © 2021 Łukasz Kasperek. All rights reserved.
//

import SwiftUI

struct TrainingBottomBar: View {
    @Binding var workoutName: String
    let leftArrowDisabled: Bool
    let rightArrowDisabled: Bool
    let onLeftTapped: () -> Void
    let onRightTapped: () -> Void
    let onPlusTapped: () -> Void
    
    var body: some View {
        HStack {
            Button {
                onLeftTapped()
            } label: {
                Image(systemName: "arrow.left")
            }
            .disabled(leftArrowDisabled)
            .frame(width: 44)
            Spacer()
            TextField(
                L10n.Planner.BottomBar.WorkoutName.placeholder,
                text: $workoutName
            )
                .multilineTextAlignment(.center)
            Spacer()
            Button {
                onPlusTapped()
            } label: {
                Image(systemName: "plus")
            }
            .frame(width: 44)
            Button {
                onRightTapped()
            } label: {
                Image(systemName: "arrow.right")
            }
            .disabled(rightArrowDisabled)
            .frame(width: 44)
        }
        .font(.system(
            size: 18,
            weight: .medium,
            design: .rounded
        ))
        .padding(10)
        .frame(maxWidth: .infinity, minHeight: 56)
        .background(Color.background)
    }
}

struct TrainingBottomBar_Previews: PreviewProvider {
    static var previews: some View {
        TrainingBottomBar(
            workoutName: .constant("A1"),
            leftArrowDisabled: false,
            rightArrowDisabled: true,
            onLeftTapped: {},
            onRightTapped: {},
            onPlusTapped: {}
        )
            .cellPreview()
    }
}
