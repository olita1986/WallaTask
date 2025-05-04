//
//  UIView+OnTap.swift
//  WallaMarvel
//
//  Created by orlando arzola on 04-05-25.
//

import UIKit

extension UIView {
    func onTap(_ action: @escaping () -> Void) {
        let gesture = TapGesture { _ in
            action()
        }
        addGestureRecognizer(gesture)
        isUserInteractionEnabled = true
    }
}

final class TapGesture: UITapGestureRecognizer {
    let action: (UITapGestureRecognizer) -> Void
    
    init(action: @escaping (UITapGestureRecognizer) -> Void) {
        self.action = action
        super.init(target: nil, action: nil)
        addTarget(self, action: #selector(handleAction))
    }
    
    @objc
    func handleAction(_ recognizer: UITapGestureRecognizer) {
        action(recognizer)
    }
}
