//
//  GraphicalSelector.swift
//  Core
//
//  Created by Łukasz Kasperek on 07/04/2020.
//  Copyright © 2020 Łukasz Kasperek. All rights reserved.
//

import SwiftUI

extension GraphicalSelector {
    struct Model {
        struct Option {
            let image: Image
            let description: String
        }
        
        let options: [Option]
        var selectedIndex: Int = 0
        
        var selectedOption: Option {
            return options[selectedIndex]
        }
    }
}

struct GraphicalSelector: View {
    @Binding var model: Model
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                ForEach(model.options.indices) { index in
                    Button(action: {
                        self.model.selectedIndex = index
                    }) {
                        self.model.options[index].image
                            .foregroundColor(self.color(for: index))
                            .padding()
                            .frame(minWidth: 100, minHeight: 100)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(self.color(for: index))
                            )
                    }
                }
            }
            Text(self.model.selectedOption.description)
                .font(.footnote)
        }
    }
    
    private func color(for index: Int) -> Color {
        return model.selectedIndex == index ? .theme : .border
    }
}

struct GraphicalSelector_Previews: PreviewProvider {
    static let model = GraphicalSelector.Model(
        options: [
            .init(
                image: Image(systemName: "paperplane.fill"),
                description: "Some pretty long description, just to check."
            ),
            .init(
                image: Image(systemName: "folder.fill"),
                description: "Another fairly long description."
            ),
            .init(
                image: Image(systemName: "tray.fill"),
                description: "This one isn't that short either."
            ),
        ],
        selectedIndex: 0
    )
    
    static var previews: some View {
        PreviewWrapper<GraphicalSelector>(model: model)
    }
}

extension GraphicalSelector: WrappablePreviewView {}
