//
//  BiSelector.swift
//  Weights
//
//  Created by Łukasz Kasperek on 28/12/2019.
//  Copyright © 2019 Łukasz Kasperek. All rights reserved.
//

import SwiftUI

class BiSelectorModel: ObservableObject {
    let options: [String]
    @Published var selectedIndex: Int?
    
    init(options: [String], selectedIndex: Int? = nil) {
        precondition(options.count == 2)
        self.options = options
        self.selectedIndex = selectedIndex
    }
}

private let biSelectorCoordinateSpace = "biSelectorCoordinateSpace"

struct BiSelector: View {
    @ObservedObject var model: BiSelectorModel
    @State private var buttonRects: [CGRect] = Array(repeating: .zero, count: 2)
    
    var body: some View {
        HStack(spacing: 0) {
            BiSelectorButton(
                index: 0,
                title: self.model.options[0],
                selectedIndex: self.$model.selectedIndex
            )
            BiSelectorButton(
                index: 1,
                title: self.model.options[1],
                selectedIndex: self.$model.selectedIndex
            )
        }
        .coordinateSpace(name: biSelectorCoordinateSpace)
        .onPreferenceChange(SelectionMarkerPreferenceKey.self) { preferences in
            for preference in preferences {
                self.buttonRects[preference.index] = preference.rect
            }
        }
        .font(.subheadline)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .foregroundColor(.theme)
                .padding(2)
                .frame(
                    width: selectedButtonRect.width,
                    height: selectedButtonRect.height,
                    alignment: .topLeading
            )
                .offset(x: selectedButtonRect.minX, y: 0),
            alignment: .leading
        )
            .background(
                RoundedRectangle(cornerRadius: 16)
                .foregroundColor(.background)
                .outerDepthShadow()
        )
    }
    
    private var selectedButtonRect: CGRect {
        guard let index = model.selectedIndex else { return .zero }
        return buttonRects[index]
    }
}

private struct BiSelectorButton: View {
    let index: Int
    let title: String
    @Binding var selectedIndex: Int?
    
    var body: some View {
        GeometryReader { geometry in
            Button(action: {
                withAnimation(.easeInOut(duration: 0.15)) {
                    self.selectedIndex = self.index
                }
            }) {
                Text(self.title)
                    .foregroundColor(
                        self.selectedIndex == self.index
                            ? .white
                            : .label
                    )
                    .padding(.init(top: 8, leading: 12, bottom: 8, trailing: 12))
            }
            .preference(
                key: SelectionMarkerPreferenceKey.self,
                value: [SelectionMarkerPreferenceKey.Data(
                    index: self.index,
                    rect: geometry.frame(in: .named(biSelectorCoordinateSpace))
                )]
            )
        }
        .frame(height: 48)
    }
}

private struct SelectionMarkerPreferenceKey: PreferenceKey {
    struct Data: Equatable {
        let index: Int
        let rect: CGRect
    }
    
    typealias Value = [Data]
    
    static var defaultValue: [Data] = []
    
    static func reduce(
        value: inout [SelectionMarkerPreferenceKey.Data],
        nextValue: () -> [SelectionMarkerPreferenceKey.Data]
    ) {
        value.append(contentsOf: nextValue())
    }
}

struct BiSelector_Previews: PreviewProvider {
    static let model = BiSelectorModel(
        options: ["Reps", "Duration"],
        selectedIndex: 0
    )
    
    static var previews: some View {
        BiSelector(model: model)
            .padding(40)
            .previewLayout(.fixed(width: 300, height: 500))
            .background(Color.background)
    }
}
