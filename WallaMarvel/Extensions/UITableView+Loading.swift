//
//  UITableView+Loading.swift
//  WallaMarvel
//
//  Created by orlando arzola on 04-05-25.
//

import UIKit

extension UITableView {
    func showLoading(loadingText: String) {
        let view = UIView(frame: self.bounds)
        let label = UILabel()
        label.text = loadingText
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.startAnimating()
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .center
        stackView.addArrangedSubview(indicator)
        stackView.addArrangedSubview(label)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        self.backgroundView = view
    }
    
    func hideLoading() {
        self.backgroundView = nil
    }
}
