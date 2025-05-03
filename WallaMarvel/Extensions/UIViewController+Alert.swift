//
//  UIViewController+Alert.swift
//  WallaMarvel
//
//  Created by orlando arzola on 02-05-25.
//

import UIKit

extension UIViewController {
    func showAlert(title: String = "Error", message: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        alert.view.accessibilityIdentifier = AccessibilityIdentifiers.General.alert
        let defaultAction = UIAlertAction(title: "OK", style: .default)
        
        alert.addAction(defaultAction)

        present(alert, animated: true)
    }
}
