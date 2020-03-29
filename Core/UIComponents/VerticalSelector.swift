//
//  VerticalSelector.swift
//  Weights
//
//  Created by Łukasz Kasperek on 28/03/2020.
//  Copyright © 2020 Łukasz Kasperek. All rights reserved.
//

import SwiftUI

struct VerticalSelector: View {
    struct Model {
        let options: [String]
        var selectedIndex: Int
    }
    
    @Binding var model: Model
    
    var body: some View {
        VStack(alignment: .leading) {
            ForEach(0 ..< model.options.count) { index in
                OptionButton(
                    text: self.model.options[index],
                    index: index,
                    selectedIndex: self.$model.selectedIndex
                )
                .frame(maxWidth: .infinity)
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 16)
                .foregroundColor(.background)
                .outerDepthShadow()
        )
    }
}

private struct OptionButton: View {
    let text: String
    let index: Int
    @Binding var selectedIndex: Int
    
    var body: some View {
        Button(action: { self.selectedIndex = self.index }) {
            Text(text)
            .scaleEffect(
                x: isSelected ? 1.15 : 1,
                y: isSelected ? 1.15 : 1,
                anchor: .leading
            )
            .foregroundColor(isSelected ? .theme : .label)
            .padding(EdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12))
            .font(.body)
        }
    }
    
    private var isSelected: Bool {
        return selectedIndex == index
    }
}

struct VerticalSelector_Previews: PreviewProvider {
    static var previews: some View {
        PreviewWrapper<VerticalSelector, VerticalSelector.Model>(
            model: .init(
                options: [
                    "Unilateral",
                    "Multiset unilateral",
                    "Bilateral"
                ],
                selectedIndex: 0
            )
        )
        .previewLayout(.fixed(width: 300, height: 500))
        .padding(40)
        .background(Color.background)
    }
}

extension VerticalSelector: WrappablePreviewView {}
