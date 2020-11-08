//
//  ColorPreviews.swift
//  Core
//
//  Created by Łukasz Kasperek on 25/10/2020.
//  Copyright © 2020 Łukasz Kasperek. All rights reserved.
//

import SwiftUI

struct ColorPreviews_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Color.background
            Color.secondaryBackground
            Color.groupedBackground
            Color.secondaryFill
        }
    }
}
