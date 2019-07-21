//
//  QuickSelector.swift
//  Weights
//
//  Created by Łukasz Kasperek on 15/06/2019.
//  Copyright © 2019 Łukasz Kasperek. All rights reserved.
//

import SwiftUI
import Combine


class QuickSelectorModel: BindableObject {
    let willChange = PassthroughSubject<Void, Never>()
    
	struct Option: Identifiable {
		let id: Int
		let title: String
	}
	
	let title: String
	let options: [Option]
    var selectedOption: Option? {
        didSet { willChange.send() }
    }
	
	init(title: String, options: [Option]) {
		self.title = title
		self.options = options
        self.selectedOption = options.first!
	}
}

struct QuickSelector : View {
	@ObjectBinding var model: QuickSelectorModel

    var body: some View {
        VStack(alignment: .leading) {
            Text(model.title)
                .font(.caption)
                .foregroundColor(.label)
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
            .frame(maxHeight: 50)
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
        }, label: {
            Text(option.title)
                .foregroundColor(themeColor())
                .padding(8)
                .border(themeColor(), cornerRadius: 16)
        })
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
            title: "Laterality",
            options: [
                .init(id: 0, title: "Unilateral"),
                .init(id: 1, title: "Bilateral")
            ])
    }
}
#endif
