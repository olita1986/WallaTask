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

        present(alert, animated: true)
    }
}
