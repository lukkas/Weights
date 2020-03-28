//
//  DoubleSelector.swift
//  Weights
//
//  Created by Łukasz Kasperek on 16/02/2020.
//  Copyright © 2020 Łukasz Kasperek. All rights reserved.
//

import SwiftUI

class MyViewModel: ObservableObject {
    @Published var selectedButtonIndex: Int? = 0
    
    var jakisButton: DoubleSelectorViewModel {
        get {
            return DoubleSelectorViewModel(
                titles: [],
                selectedIndex: selectedButtonIndex
            )
        }
        set {
            selectedButtonIndex = newValue.selectedIndex
        }
    }
}

struct WrapperView: View {
    @ObservedObject var vm: MyViewModel
    
    var body: some View {
        DoubleSelector(viewModel: $vm.jakisButton)
    }
}

struct DoubleSelectorViewModel {
    let titles: [String]
    var selectedIndex: Int?
}

struct DoubleSelector: View {
    @Binding var viewModel: DoubleSelectorViewModel
    @State var show: Bool = true
    
    var body: some View {
        HStack {
            Button(action: { self.show.toggle() }) {
                DoubleSelectorButtonLabel(
                    title: viewModel.titles[0],
                    state: buttonState(for: 0)
                )
            }
            Button(action: {}) {
                DoubleSelectorButtonLabel(
                    title: viewModel.titles[1],
                    state: buttonState(for: 1)
                )
            }.frame(width: 1, height: 50)
        }
    }
    
    private func buttonState(for index: Int) -> DoubleSelectorButtonLabel.State {
        guard let selectedIndex = viewModel.selectedIndex else {
            return .noneSelected
        }
        return selectedIndex == index ? .selected : .otherSelected
    }
}

private struct DoubleSelectorButtonLabel: View {
    enum State {
        case noneSelected, otherSelected, selected
    }
    
    let title: String
    let state: State
    
    var body: some View {
        Text(title)
            .padding()
            .background(
                ZStack {
                    Color.secondarySystemBackground
                    Color.red
                        .frame(
                            width: state == .selected ? nil : 0,
                            height: state == .selected ? nil : 0
                        )
                        .animation(.spring())
                }
        )
        .cornerRadius(16)
    }
}

struct DoubleSelector_Previews: PreviewProvider {
    static var previews: some View {
        DoubleSelector(
            viewModel: .constant(
                DoubleSelectorViewModel(
                    titles: ["Unilateral", "Bilateral"],
                    selectedIndex: 1
                )
            )
        )
    }
}
