//
//  STPaywallDetailNoticeCell.swift
//  STPaywallUIKit
//

import SnapKit
import UIKit

final class STPaywallDetailNoticeCell: UITableViewCell {
    deinit { }

    // MARK: - UI Components

    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = STPaywallColors.cardBackground
        view.layer.cornerRadius = 16
        return view
    }()

    private lazy var noticeLabel: UILabel = {
        let label = UILabel()
        label.font = STPaywallTypography.caption1
        label.textColor = STPaywallColors.textSecondary
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

        self.contentView.addSubview(self.containerView)
        self.containerView.addSubview(self.noticeLabel)

        self.containerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.bottom.equalToSuperview().inset(8)
        }

        self.noticeLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
    }

    // MARK: - Configuration

    func configure(text: String) {
        self.noticeLabel.text = text
    }
}
