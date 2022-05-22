//
//  PaceKeyboardController.swift
//  Core
//
//  Created by Łukasz Kasperek on 15/05/2022.
//

import SwiftUI
import UIKit

class PaceKeyboardController: UIInputViewController {
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 298)
        addHostingControllerAsChild()
    }
    
    private func addHostingControllerAsChild() {
        let child = UIHostingController(rootView: makeKeyboardView())
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
    
    private func makeKeyboardView() -> PaceKeyboard {
        let keyboard = PaceKeyboard(
            onKeyTapped: { [weak self] key in
                self?.textDocumentProxy.insertText(key)
            },
            onDeleteTapped: { [weak self] in
                self?.textDocumentProxy.deleteBackward()
            }
        )
        return keyboard
    }
}
