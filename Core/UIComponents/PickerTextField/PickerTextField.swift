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
    @Binding var value: Double
    
    func makeUIView(context: Context) -> UIPickerTextField {
        return UIPickerTextField()
    }
    
    func updateUIView(_ uiView: UIPickerTextField, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    class Coordinator: NSObject {
        var textField: PickerTextField
        
        init(_ textField: PickerTextField) {
            self.textField = textField
        }
        
        
    }
}
