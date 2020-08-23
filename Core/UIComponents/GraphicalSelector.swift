//
//  GraphicalSelector.swift
//  Core
//
//  Created by Łukasz Kasperek on 07/04/2020.
//  Copyright © 2020 Łukasz Kasperek. All rights reserved.
//

import SwiftUI

struct GraphicalSelector: View {
    struct Option {
        let image: Image
        let description: String
    }
    
    @Binding private var selection: Int
    private let options: [Option]
    private var selectedOption: Option { options[selection] }
    
    init(selection: Binding<Int>, options: [Option]) {
        _selection = selection
        self.options = options
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                ForEach(options.indices) { index in
                    Button(action: {
                        self.selection = index
                    }) {
                        self.options[index].image
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
            Text(self.selectedOption.description)
                .font(.footnote)
        }
    }
    
    private func color(for index: Int) -> Color {
        return selection == index ? .theme : .border
    }
}

struct GraphicalSelector_Previews: PreviewProvider {
    static var previews: some View {
        Wrapper()
    }
    
    private struct Wrapper: View {
        @State var selection = 0
        
        var body: some View {
            GraphicalSelector(
                selection: $selection,
                options: options
            )
        }
        
        private var options: [GraphicalSelector.Option] {
            [
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
                )
            ]
        }
    }
}
