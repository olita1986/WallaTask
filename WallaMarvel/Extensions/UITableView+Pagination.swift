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
    
    func showPaginationError(message: String) {
        let label = UILabel()
        label.text = message
        label.textAlignment = .center
        label.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: 44)
        tableFooterView = label
    }
}
