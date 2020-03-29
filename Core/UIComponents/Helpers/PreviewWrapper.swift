//
//  PreviewWrapper.swift
//  Core
//
//  Created by Łukasz Kasperek on 29/03/2020.
//  Copyright © 2020 Łukasz Kasperek. All rights reserved.
//

import Foundation
import SwiftUI

struct PreviewWrapper<WrappedView: WrappablePreviewView, Model>: View where WrappedView.Model == Model {
    @State var model: Model
    
    var body: some View {
        WrappedView(model: $model)
    }
}

protocol WrappablePreviewView: View {
    associatedtype Model
    
    init(model: Binding<Model>)
}
