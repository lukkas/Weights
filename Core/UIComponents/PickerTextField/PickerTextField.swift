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
    private var fillColor: Color = .secondaryFill
    private var borderColor: Color? = nil
    private var mode: UIPickerTextField.Mode = .wholes
    private var jumpInterval: Double? = 1
    private var minMaxRange: ClosedRange<Double>? = nil
    
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
        uiView.backgroundColor = UIColor(fillColor)
        uiView.borderColor = borderColor.map(UIColor.init)
        uiView.mode = mode
        uiView.minMaxRange = minMaxRange
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
    
    func fillColor(_ color: Color) -> PickerTextField {
        var copy = self
        copy.fillColor = color
        return copy
    }
    
    func borderColor(_ color: Color) -> PickerTextField {
        var copy = self
        copy.borderColor = color
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
}

struct PickerTextField_Previews: PreviewProvider {
    struct Wrapper: View {
        @State var value: Double? = nil
        
        var body: some View {
            PickerTextField(value: $value)
                .fillColor(.fill)
        }
    }
    
    static var previews: some View {
        Wrapper()
    }
}
