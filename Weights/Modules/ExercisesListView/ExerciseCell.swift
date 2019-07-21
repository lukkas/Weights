//
//  ExerciseCell.swift
//  Weights
//
//  Created by Łukasz Kasperek on 14/07/2019.
//  Copyright © 2019 Łukasz Kasperek. All rights reserved.
//

import SwiftUI

struct ExerciseCell : View {
    let model: ExerciseCellModel
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(model.name)
                Text(model.muscleGroup)
                    .font(.caption)
                    .foregroundColor(Color.secondaryLabel)
            }
            Spacer()
            Text(model.nextPerformance)
                .font(.callout)
                .foregroundColor(.tertiaryLabel)
        }
        .padding()
    }
}

#if DEBUG
struct ExerciseCell_Previews : PreviewProvider {    
    static var previews: some View {
        ExerciseCell(model: .sample)
    }
}
#endif
