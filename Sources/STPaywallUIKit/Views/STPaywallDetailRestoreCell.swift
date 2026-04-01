//
//  STPaywallDetailRestoreCell.swift
//  STPaywallUIKit
//

import SnapKit
import UIKit

final class STPaywallDetailRestoreCell: UITableViewCell {
    deinit { }

    // MARK: - UI Components

    private lazy var restoreButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSAttributedString(
            string: I18N.detail_restore_desc,
            attributes: [
                .font: STPaywallTypography.caption1,
                .foregroundColor: STPaywallColors.textTertiary,
                .underlineStyle: NSUnderlineStyle.single.rawValue
            ]
        )
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(self.buttonTapped), for: .touchUpInside)
        return button
    }()

    // MARK: - Properties

    private var onTap: (() -> Void)?

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

        self.contentView.addSubview(self.restoreButton)

        self.restoreButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.bottom.equalToSuperview().inset(4)
        }
    }

    // MARK: - Configuration

    func configure(onTap: @escaping () -> Void) {
        self.onTap = onTap
    }

    // MARK: - Actions

    @objc private func buttonTapped() {
        self.onTap?()
    }
}
