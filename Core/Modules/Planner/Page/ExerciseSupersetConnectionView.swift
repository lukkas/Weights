//
//  ExerciseSupersetConnectionView.swift
//  Core
//
//  Created by Łukasz Kasperek on 28/01/2023.
//

import SwiftUI

struct ExerciseSupersetConnectionView: View {
    let buttonTapped: () -> Void
    
    var body: some View {
        HStack {
            Color.separator
                .frame(height: 1)
                .padding(.horizontal)
            Button {
                buttonTapped()
            } label: {
                Image(systemName: "link.circle")
            }
            .textStyle(.largeIconButton)
            Color.separator
                .frame(height: 1)
                .padding(.horizontal)
        }
    }
}

struct ExerciseSupersetConnectionView_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseSupersetConnectionView(buttonTapped: { })
    }
}
