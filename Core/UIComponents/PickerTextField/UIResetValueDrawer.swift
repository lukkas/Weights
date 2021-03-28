//
//  UIResetValueDrawer.swift
//  Core
//
//  Created by Łukasz Kasperek on 24/03/2021.
//  Copyright © 2021 Łukasz Kasperek. All rights reserved.
//

import Foundation
import UIKit

class UIResetValueDrawer: UIView {
    private let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) { fatalError("Storyboards are not compatible with truth and beauty") }
    
    override func layoutSubviews() {
        imageView.frame = bounds
    }
    
    private func setUp() {
        applyStyling()
        addImageViewAsSubview()
    }
    
    private func applyStyling() {
        backgroundColor = UIColor.systemRed
    }
    
    private func addImageViewAsSubview() {
        addSubview(imageView)
        imageView.tintColor = .white
        imageView.image = UIImage(systemName: "xmark")
        imageView.contentMode = .center
    }
}
