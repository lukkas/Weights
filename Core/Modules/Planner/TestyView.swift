//
//  TestyView.swift
//  Core
//
//  Created by Łukasz Kasperek on 13/03/2022.
//

import SwiftUI

class MyVM: ObservableObject {
    @Published var selectedTab: Int = 0
}

struct TestyView: View {
    @StateObject var viewModel = MyVM()
    @State var index: Int = 0
    private let numbers = [0, 1, 2]
    
    var body: some View {
        TabView(selection: $viewModel.selectedTab) {
            ForEach(0 ..< numbers.endIndex) { value in
                Text("\(value)")
                    .background(Color.red)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .automatic))
        .id(index)
            .background(Color.blue)
    }
}

struct TestyView_Previews: PreviewProvider {
    static var previews: some View {
        TestyView()
    }
}
