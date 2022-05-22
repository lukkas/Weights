//
//  PaceKeyboardController.swift
//  Core
//
//  Created by Łukasz Kasperek on 15/05/2022.
//

import SwiftUI
import UIKit

class PaceKeyboardController: UIInputViewController {
    private var onKeyTapped: ((String) -> ())!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 240)
        addHostingControllerAsChild()
    }
    
    private func addHostingControllerAsChild() {
        onKeyTapped = { [weak self] key in
            self?.textDocumentProxy.insertText(key)
        }
        let keyboard = PaceKeyboard(onKeyTapped: onKeyTapped)
        let child = UIHostingController(rootView: keyboard)
        addChild(child)
        view.addSubview(child.view)
        child.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            child.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            child.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            child.view.topAnchor.constraint(equalTo: view.topAnchor),
            child.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        child.didMove(toParent: self)
    }
}
