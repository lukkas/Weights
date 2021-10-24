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
    let themeColor: Color
    let mode: UIPickerTextField.Mode
    let jumpInterval: Double?
    let minMaxRange: ClosedRange<Double>?
    
    func makeUIView(context: Context) -> UIPickerTextField {
        let field = UIPickerTextField()
        field.themeColor = UIColor(themeColor)
        field.mode = mode
        field.jumpInterval = jumpInterval
        field.minMaxRange = minMaxRange
        field.addTarget(
            context.coordinator,
            action: #selector(Coordinator.updateValue(sender:)),
            for: .valueChanged
        )
        return field
    }
    
    func updateUIView(_ uiView: UIPickerTextField, context: Context) {
        uiView.value = value
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
