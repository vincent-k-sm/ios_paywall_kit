//
//  UITableView+STPaywall.swift
//  STPaywallUIKit
//

import UIKit

extension UITableViewCell {
    static var stIdentifier: String {
        return String(describing: self)
    }
}

extension UITableView {
    func stRegisterCell<T: UITableViewCell>(type: T.Type) {
        self.register(type, forCellReuseIdentifier: type.stIdentifier)
    }
}
