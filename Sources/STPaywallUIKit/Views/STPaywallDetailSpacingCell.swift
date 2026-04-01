//
//  STPaywallDetailSpacingCell.swift
//  STPaywallUIKit
//

import SnapKit
import UIKit

final class STPaywallDetailSpacingCell: UITableViewCell {
    deinit { }

    // MARK: - Properties

    private var heightConstraint: NSLayoutConstraint?

    // MARK: - Initialization

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup Methods

    private func setupUI() {
        self.selectionStyle = .none
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear

        let spacingView = UIView()
        spacingView.backgroundColor = .clear
        self.contentView.addSubview(spacingView)

        spacingView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    // MARK: - Configuration

    func configure(height: CGFloat) {
        // Height는 UITableViewDelegate의 heightForRowAt에서 처리
    }
}
