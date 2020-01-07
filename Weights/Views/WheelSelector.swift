//
//  WheelSelector.swift
//  Weights
//
//  Created by Łukasz Kasperek on 02/01/2020.
//  Copyright © 2020 Łukasz Kasperek. All rights reserved.
//

import SwiftUI

class WheelSelectorModel: ObservableObject {
    struct Option: Identifiable {
        let id = UUID()
        let name: String
        let image: Image
    }
    
    let options: [Option]
    @Published var selectedIndex: Int
    
    init(options: [Option], selectedIndex: Int) {
        self.options = options
        self.selectedIndex = selectedIndex
    }
}

struct WheelSelector: View {
    @ObservedObject var model: WheelSelectorModel
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Circle()
                    .fill(Color.secondarySystemBackground)
                    .overlay(
                        Circle().inset(by: 50).foregroundColor(.systemBackground)
                    )
                    .shadow(radius: 1)
                    .modifier(
                        SelectionMarker(
                            selectedItemIndex: self.model.selectedIndex,
                            numberOfItems: self.model.options.count
                        )
                    )
                ForEach(0 ..< self.model.options.count) { index in
                    WheelSelectorOptionMarker(option: self.model.options[index])
                        .offset(self.offset(
                            forMarkerAt: index,
                            radius: (geometry.size.shorterDimension - 50) * 0.5
                        ))
                        .foregroundColor(
                            self.model.selectedIndex == index
                                ? .white
                                : .systemGray
                    ).onTapGesture {
                        withAnimation {
                            self.model.selectedIndex = index
                        }
                    }
                }
                Text(self.model.options[self.model.selectedIndex].name).font(.body)
            }
        }
        .frame(width: 250, height: 300)
    }
    
    private func offset(forMarkerAt index: Int, radius: CGFloat) -> CGSize {
        let optionFraction = Double(index) / Double(model.options.count)
        let angle = Angle(degrees: -optionFraction * 360 + 180)
        let xOffset = CGFloat(sin(angle.radians)) * radius
        let yOffset = CGFloat(cos(angle.radians)) * radius
        return CGSize(
            width: xOffset,
            height: yOffset
        )
    }
}

private struct SelectionMarker: AnimatableModifier {
    var selectedItemIndex: Int {
        get { Int(_selectedItemIndex) }
        set { _selectedItemIndex = Double(newValue) }
    }
    let numberOfItems: Int
    
    init(selectedItemIndex: Int, numberOfItems: Int) {
        self._selectedItemIndex = Double(selectedItemIndex)
        self.numberOfItems = numberOfItems
    }
    
    private var _selectedItemIndex: Double
    
    var animatableData: Double {
        get { return _selectedItemIndex }
        set { _selectedItemIndex = newValue }
    }
    
    func body(content: Content) -> some View {
        content.overlay(
            ArcShape(
                selectedItemIndex: _selectedItemIndex,
                numberOfItems: numberOfItems
            )
            .fill(Color.appTheme)
        )
    }
    
    private struct ArcShape: Shape {
        let selectedItemIndex: Double
        let numberOfItems: Int
        
        func path(in rect: CGRect) -> Path {
            var path = Path()
            path.addArc(
                center: rect.center,
                radius: (rect.size.shorterDimension - 50) * 0.5,
                startAngle: markerCenterAngle - perItemAngle * 0.2,
                endAngle: markerCenterAngle + perItemAngle * 0.2,
                clockwise: false
            )
            return path.strokedPath(strokeStyle)
        }
        
        private var markerCenterAngle: Angle {
            let fraction = Double(selectedItemIndex) / Double(numberOfItems)
            return Angle(degrees: fraction * 360 - 90)
        }
        
        private var perItemAngle: Angle {
            let fraction = 1 / Double(numberOfItems)
            return Angle(degrees: fraction * 360)
        }
        
        private var strokeStyle: StrokeStyle {
            return StrokeStyle(
                lineWidth: 44,
                lineCap: .round
            )
        }
    }
}

private struct WheelSelectorOptionMarker: View {
    let option: WheelSelectorModel.Option
    
    var body: some View {
        option.image
    }
}

private struct WheelSelectorKnob: View {
    var body: some View {
        Circle()
            .stroke(lineWidth: 3)
            .foregroundColor(.appTheme)
    }
}

struct WheelSelector_Previews: PreviewProvider {
    static var previews: some View {
        WheelSelector(model: .init(options: options, selectedIndex: 0))
    }
    
    static var options: [WheelSelectorModel.Option] =
        [
            .init(name: "Biceps", image: Image(systemName: "eye")),
            .init(name: "Biceps", image: Image(systemName: "ear")),
            .init(name: "Biceps", image: Image(systemName: "hand.thumbsup")),
            .init(name: "Biceps", image: Image(systemName: "hand.thumbsdown")),
            .init(name: "Biceps", image: Image(systemName: "hand.raised")),
            .init(name: "Biceps", image: Image(systemName: "eye")),
            .init(name: "Biceps", image: Image(systemName: "ear")),
            .init(name: "Biceps", image: Image(systemName: "hand.thumbsup")),
            .init(name: "Biceps", image: Image(systemName: "hand.thumbsdown")),
            .init(name: "Biceps", image: Image(systemName: "hand.raised")),
            .init(name: "Biceps", image: Image(systemName: "ear")),
            .init(name: "Biceps", image: Image(systemName: "hand.thumbsup"))
        ]
}
