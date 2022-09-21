//
//  PickerTextField.swift
//  Core
//
//  Created by Łukasz Kasperek on 29/12/2020.
//  Copyright © 2020 Łukasz Kasperek. All rights reserved.
//

import Foundation
import SwiftUI
import UIKit

struct PickerTextField: UIViewRepresentable {
    @Binding var value: Double?
    private var themeColor: Color = .accentColor
    private var fillColor: Color? = .secondaryFill
    private var highlightColor: Color? = nil
    private var fontSize: CGFloat = 18
    private var mode: UIPickerTextField.Mode = .wholes
    private var jumpInterval: Double? = 1
    private var minMaxRange: ClosedRange<Double>? = nil
    private var highlightStyle: UIPickerTextField.HightlightStyle = .border
    
    init(value: Binding<Double?>) {
        _value = value
    }
    
    func makeUIView(context: Context) -> UIPickerTextField {
        let field = UIPickerTextField()
        applyModifiers(to: field)
        field.addTarget(
            context.coordinator,
            action: #selector(Coordinator.updateValue(sender:)),
            for: .valueChanged
        )
        return field
    }
    
    func updateUIView(_ uiView: UIPickerTextField, context: Context) {
        applyModifiers(to: uiView)
    }
    
    private func applyModifiers(to uiView: UIPickerTextField) {
        uiView.value = value
        uiView.tintColor = UIColor(themeColor)
        uiView.backgroundColor = fillColor.map(UIColor.init)
        uiView.highlightColor = highlightColor.map(UIColor.init)
        uiView.mode = mode
        uiView.minMaxRange = minMaxRange
        uiView.fontSize = fontSize
        uiView.highlightStyle = highlightStyle
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    class Coordinator: NSObject {
        var textField: PickerTextField
        
        init(_ textField: PickerTextField) {
            self.textField = textField
        }
        
        @objc func updateValue(sender: UIPickerTextField) {
            textField.value = sender.value
        }
    }
}

extension PickerTextField {
    func themeColor(_ color: Color) -> PickerTextField {
        var copy = self
        copy.themeColor = color
        return copy
    }
    
    func fillColor(_ color: Color?) -> PickerTextField {
        var copy = self
        copy.fillColor = color
        return copy
    }
    
    func highlightColor(_ color: Color) -> PickerTextField {
        var copy = self
        copy.highlightColor = color
        return copy
    }
    
    func mode(_ mode: UIPickerTextField.Mode) -> PickerTextField {
        var copy = self
        copy.mode = mode
        return copy
    }
    
    func jumpInterval(_ interval: Double?) -> PickerTextField {
        var copy = self
        copy.jumpInterval = interval
        return copy
    }
    
    func minMaxRange(_ range: ClosedRange<Double>?) -> PickerTextField {
        var copy = self
        copy.minMaxRange = range
        return copy
    }
    
    func fontSize(_ size: CGFloat) -> PickerTextField {
        var copy = self
        copy.fontSize = size
        return copy
    }
    
    func highlightStyle(_ style: UIPickerTextField.HightlightStyle) -> PickerTextField {
        var copy = self
        copy.highlightStyle = style
        return copy
    }
}

struct PickerTextField_Previews: PreviewProvider {
    struct Wrapper: View {
        @State var value: Double?
        let fontSize: CGFloat
        let fillColor: Color?
        let highlightStyle: UIPickerTextField.HightlightStyle
        
        init(
            value: Double? = 0,
            fontSize: CGFloat = 18,
            fillColor: Color? = .fill,
            highlightStyle: UIPickerTextField.HightlightStyle = .border
        ) {
            self.value = value
            self.fontSize = fontSize
            self.fillColor = fillColor
            self.highlightStyle = highlightStyle
        }
        
        var body: some View {
            PickerTextField(value: $value)
                .fillColor(fillColor)
                .fontSize(fontSize)
                .highlightStyle(highlightStyle)
        }
    }
    
    static var previews: some View {
        Wrapper()
            .previewDisplayName("Regular appearance")
        Wrapper(fillColor: nil)
            .previewDisplayName("No fill")
        Wrapper(highlightStyle: .underline)
            .previewDisplayName("Underline highlight")
        Wrapper(fontSize: 24)
            .previewDisplayName("Large font")
        Wrapper(fontSize: 36)
            .previewDisplayName("Very large font")
        Wrapper(fontSize: 52)
            .previewDisplayName("Enormous font")
    }
}
