//
//  View+Debug.swift
//  Core
//
//  Created by Łukasz Kasperek on 23/08/2020.
//  Copyright © 2020 Łukasz Kasperek. All rights reserved.
//

import SwiftUI

extension View {
    func debug() -> Self {
        print(Mirror(reflecting: self).subjectType)
        return self
    }
}
