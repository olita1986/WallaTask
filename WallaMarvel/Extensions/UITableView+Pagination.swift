//
//  UITableView+Pagination.swift
//  WallaMarvel
//
//  Created by orlando arzola on 02-05-25.
//

import UIKit

extension UITableView {
    func showPaginationLoading() {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.startAnimating()
        spinner.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: 44)
        tableFooterView = spinner
    }
    
    func showPaginationError(message: String,  action: @escaping () -> Void) {
        tableFooterView = createErrorView(message: message, action: action)
    }
    
    private func createErrorView(message: String, action: @escaping () -> Void) -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: 80))
        let label = UILabel()
        label.text = message
        label.textAlignment = .center
        let button = UIButton()
        button.setTitle("Try Again", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.onTap {
            action()
        }
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(button)
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: view.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        return view
    }
}
