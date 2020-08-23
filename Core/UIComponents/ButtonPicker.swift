//
//  ButtonPicker.swift
//  Core
//
//  Created by Łukasz Kasperek on 09/08/2020.
//  Copyright © 2020 Łukasz Kasperek. All rights reserved.
//

import SwiftUI

struct ButtonPicker<Selection: Identifiable, Content: View>: View {
    private let selection: Binding<Selection>
    private let options: [Selection]
    private let content: (Selection) -> Content
    
    init(
        selection: Binding<Selection>,
        options: [Selection],
        @ViewBuilder content: @escaping (Selection) -> Content
    ) {
        self.selection = selection
        self.options = options
        self.content = content
    }
    
    var body: some View {
        HStack {
            ForEach(options) { option in
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                    content(option)
                })
                .padding()
                .background(Color.primaryElement)
                .cornerRadius(16)
                .outerDepthShadow()
            }
        }
    }
}

struct ButtonPicker_Previews: PreviewProvider {
    static var previews: some View {
        ButtonPicker_PreviewWrapper()
    }
}

private struct ButtonPicker_PreviewWrapper: View {
    @State var selection: String = "Reps"
    
    var body: some View {
        ButtonPicker(
            selection: $selection,
            options: ["Reps", "Duration"]
        ) {
            Text($0)
        }
        .frame(width: 320, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
        .background(Color.background)
    }
}

extension String: Identifiable {
    public var id: String {
        return self
    }
}
