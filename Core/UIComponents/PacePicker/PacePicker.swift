//
//  PacePicker.swift
//  Core
//
//  Created by Łukasz Kasperek on 30/04/2022.
//

import SwiftUI

struct PacePicker: UIViewRepresentable {
    @Binding var pace: UIPacePicker.Pace
    
    func makeUIView(context: Context) -> UIPacePicker {
        let view = UIPacePicker()
        view.addTarget(
            context.coordinator,
            action: #selector(Coordinator.updateValue(sender:)),
            for: .valueChanged
        )
        return view
    }
    
    func updateUIView(_ uiView: UIPacePicker, context: Context) {
        uiView.pace = pace
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    class Coordinator: NSObject {
        var picker: PacePicker
        
        init(_ picker: PacePicker) {
            self.picker = picker
        }
        
        @objc func updateValue(sender: UIPacePicker) {
            picker.pace = sender.pace
        }
    }
}

struct PacePicker_Previews: PreviewProvider {
    struct Wrapper: View {
        @State var pace = UIPacePicker.Pace()
        
        var body: some View {
            PacePicker(pace: $pace)
        }
    }
    
    static var previews: some View {
        Wrapper()
    }
}
