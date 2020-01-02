//
//  QuickSelector.swift
//  Weights
//
//  Created by Łukasz Kasperek on 15/06/2019.
//  Copyright © 2019 Łukasz Kasperek. All rights reserved.
//

import SwiftUI
import Combine

class QuickSelectorModel: ObservableObject {
    let willChange = PassthroughSubject<Void, Never>()
    
	struct Option: Identifiable {
		let id: Int
		let title: String
	}
	
	let options: [Option]
    var selectedOption: Option? {
        willSet { willChange.send() }
    }
	
	init(options: [Option]) {
		self.options = options
        self.selectedOption = options.first!
	}
}

struct QuickSelector : View {
	@ObservedObject var model: QuickSelectorModel

    var body: some View {
        VStack(alignment: .leading) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(model.options) { option in
                        QuickSelectorButton(
                            option: option,
                            selectedOption: self.$model.selectedOption
                        )
                    }
                }
            }
            .frame(maxHeight: 44)
        }
            .background(Color.systemBackground)
    }
}

struct QuickSelectorButton : View {
    let option: QuickSelectorModel.Option
    @Binding var selectedOption: QuickSelectorModel.Option?
    
    var body: some View {
        Button(action: {
            self.selectedOption = self.option
        }, label: { label })
    }
    
    private var label: some View {
        Text(option.title)
        .font(.caption)
        .foregroundColor(fontColor)
        .padding(8)
        .background(
            RoundedRectangle(cornerRadius: .grid)
                .foregroundColor(backgroundColor)
        )
    }
    
    private var fontColor: Color {
        return isSelected ? .systemBackground : .secondaryLabel
    }
    
    private var backgroundColor: Color {
        return isSelected ? .appTheme : .systemFill
    }
    
    private var isSelected: Bool {
        return option.id == selectedOption?.id
    }
    private func themeColor() -> Color {
        return option.id == selectedOption?.id ? .appTheme : .tertiaryLabel
    }
}

#if DEBUG
struct QuickSelector_Previews : PreviewProvider {
    static var previews: some View {
        QuickSelector(model: .sample)
    }
}
#endif

#if DEBUG
extension QuickSelectorModel {
    static var sample: QuickSelectorModel {
        QuickSelectorModel(
            options: [
                .init(id: 0, title: "Unilateral"),
                .init(id: 1, title: "Bilateral")
            ])
    }
}
#endif
