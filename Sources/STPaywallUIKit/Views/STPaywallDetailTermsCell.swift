//
//  STPaywallDetailTermsCell.swift
//  STPaywallUIKit
//

import SnapKit
import UIKit

final class STPaywallDetailTermsCell: UITableViewCell {
    deinit { }

    // MARK: - UI Components

    private lazy var termsButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSAttributedString(
            string: I18N.detail_terms_link,
            attributes: [
                .font: STPaywallTypography.caption1,
                .foregroundColor: STPaywallColors.primary,
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

        self.contentView.addSubview(self.termsButton)

        self.termsButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.top.bottom.equalToSuperview().inset(8)
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
