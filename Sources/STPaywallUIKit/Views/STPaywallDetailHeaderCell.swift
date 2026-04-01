//
//  STPaywallDetailHeaderCell.swift
//  STPaywallUIKit
//

import SnapKit
import UIKit

final class STPaywallDetailHeaderCell: UITableViewCell {
    deinit { }

    // MARK: - UI Components

    private lazy var iconLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 56)
        label.textAlignment = .center
        return label
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 26, weight: .bold)
        label.textColor = STPaywallColors.textPrimary
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = STPaywallTypography.body
        label.textColor = STPaywallColors.textSecondary
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

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

        self.contentView.addSubview(self.iconLabel)
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.subtitleLabel)

        self.iconLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(32)
            make.centerX.equalToSuperview()
        }

        self.titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.iconLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(24)
        }

        self.subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(24)
            make.bottom.equalToSuperview().inset(16)
        }
    }

    // MARK: - Configuration

    func configure(with viewModel: STPaywallDetailHeaderViewModel) {
        self.iconLabel.text = viewModel.emoji
        self.titleLabel.text = viewModel.title
        self.subtitleLabel.text = viewModel.subtitle
    }
}
