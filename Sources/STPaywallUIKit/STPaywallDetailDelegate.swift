//
//  STPaywallDetailDelegate.swift
//  STPaywallUIKit
//

import UIKit

protocol STPaywallDetailCellDelegate: AnyObject {
    func detailCellDidTapSubscribe(productId: String)
    func detailCellDidTapRestore()
    func detailCellDidTapTerms()
}
