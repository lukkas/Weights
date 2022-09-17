//
//  AspectRatio.swift
//  Core
//
//  Created by Łukasz Kasperek on 17/09/2022.
//

import Foundation

struct AspectRatio {
    private let ratio: Double
    
    init<T: BinaryFloatingPoint>(width: T, height: T) {
        ratio = Double(width) / Double(height)
    }
    
    init<T: BinaryInteger>(width: T, height: T) {
        ratio = Double(width) / Double(height)
    }
    
    init(size: CGSize) {
        ratio = Double(size.width) / Double(size.height)
    }
    
    func height<T: BinaryFloatingPoint>(forWidth width: T) -> T {
        return width / T(ratio)
    }
    
    func width<T: BinaryFloatingPoint>(forHeight height: T) -> T {
        return height * T(ratio)
    }
    
    func size(forWidth width: CGFloat) -> CGSize {
        return CGSize(
            width: width,
            height: height(forWidth: width)
        )
    }
}
