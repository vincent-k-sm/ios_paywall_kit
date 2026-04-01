//
//  STPaywallListHeaderView.swift
//  STPaywallUIKit
//

import SnapKit
import UIKit

final class STPaywallListHeaderView: UITableViewHeaderFooterView {
    deinit { }

    // MARK: - UI Components

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = STPaywallTypography.caption1Bold
        label.textColor = STPaywallColors.textTertiary
        return label
    }()

    // MARK: - Initialization

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup Methods

    private func setupUI() {
        self.contentView.backgroundColor = STPaywallColors.background

        self.contentView.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(STPaywallSpacing.lg)
            make.trailing.equalToSuperview().inset(STPaywallSpacing.lg)
            make.bottom.equalToSuperview().inset(STPaywallSpacing.sm)
        }
    }

    // MARK: - Configuration

    func configure(title: String) {
        self.titleLabel.text = title.uppercased()
    }
}
