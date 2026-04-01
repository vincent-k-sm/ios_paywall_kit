//
//  STPaywallListCell.swift
//  STPaywallUIKit
//

import SnapKit
import UIKit

final class STPaywallListCell: UITableViewCell {
    deinit { }

    // MARK: - UI Components

    private lazy var iconContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = STPaywallColors.chipBackground
        view.layer.cornerRadius = STPaywallRadius.sm
        return view
    }()

    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = STPaywallColors.textSecondary
        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = STPaywallTypography.body
        label.textColor = STPaywallColors.textPrimary
        return label
    }()

    private lazy var arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.tintColor = STPaywallColors.textTertiary
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.font = STPaywallTypography.caption1
        label.textColor = STPaywallColors.success
        return label
    }()

    private lazy var switchView: UISwitch = {
        let switchView = UISwitch()
        switchView.onTintColor = STPaywallColors.primary
        switchView.addTarget(self, action: #selector(self.switchValueChanged(_:)), for: .valueChanged)
        return switchView
    }()

    // MARK: - Properties

    var onSwitchChanged: ((Bool) -> Void)?

    // MARK: - Initialization

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func prepareForReuse() {
        super.prepareForReuse()
        self.titleLabel.text = nil
        self.iconImageView.image = nil
        self.statusLabel.text = nil
        self.statusLabel.isHidden = true
        self.titleLabel.textColor = STPaywallColors.textPrimary
        self.iconImageView.tintColor = STPaywallColors.textSecondary
        self.switchView.isHidden = true
        self.switchView.isEnabled = true
        self.arrowImageView.isHidden = false
        self.selectionStyle = .default
        self.onSwitchChanged = nil
    }

    // MARK: - Setup Methods

    private func setupUI() {
        self.backgroundColor = STPaywallColors.backgroundWhite
        self.selectionStyle = .default

        self.contentView.addSubview(self.iconContainerView)
        self.iconContainerView.addSubview(self.iconImageView)
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.arrowImageView)
        self.contentView.addSubview(self.statusLabel)

        self.iconContainerView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(STPaywallSpacing.lg)
            make.centerY.equalToSuperview()
            make.size.equalTo(36)
        }

        self.iconImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(18)
        }

        self.titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.iconContainerView.snp.trailing).offset(STPaywallSpacing.md)
            make.centerY.equalToSuperview()
            make.trailing.lessThanOrEqualTo(self.statusLabel.snp.leading).offset(-STPaywallSpacing.sm)
        }

        self.statusLabel.snp.makeConstraints { make in
            make.trailing.equalTo(self.arrowImageView.snp.leading).offset(-STPaywallSpacing.sm)
            make.centerY.equalToSuperview()
        }
        self.statusLabel.isHidden = true

        self.arrowImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(STPaywallSpacing.lg)
            make.centerY.equalToSuperview()
            make.size.equalTo(14)
        }

        self.contentView.addSubview(self.switchView)
        self.switchView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(STPaywallSpacing.lg)
            make.centerY.equalToSuperview()
        }
        self.switchView.isHidden = true
    }

    // MARK: - Configuration

    func configure(
        title: String,
        icon: String,
        isDestructive: Bool = false,
        statusText: String? = nil,
        hasSwitch: Bool = false,
        isSwitchOn: Bool = false,
        isDisabled: Bool = false
    ) {
        self.titleLabel.text = title
        self.iconImageView.image = UIImage(systemName: icon)

        if isDestructive {
            self.titleLabel.textColor = STPaywallColors.danger
            self.iconImageView.tintColor = STPaywallColors.danger
        }

        if isDisabled {
            self.titleLabel.textColor = STPaywallColors.textTertiary
            self.selectionStyle = .none
        }

        if let statusText = statusText {
            self.statusLabel.text = statusText
            self.statusLabel.isHidden = false
        }

        if hasSwitch {
            self.switchView.isHidden = false
            self.switchView.isOn = isSwitchOn
            self.switchView.isEnabled = !isDisabled
            self.arrowImageView.isHidden = true
            self.selectionStyle = .none
        }
        else {
            self.switchView.isHidden = true
            if !isDisabled {
                self.selectionStyle = .default
            }
        }
    }

    // MARK: - Actions

    @objc private func switchValueChanged(_ sender: UISwitch) {
        self.onSwitchChanged?(sender.isOn)
    }
}
