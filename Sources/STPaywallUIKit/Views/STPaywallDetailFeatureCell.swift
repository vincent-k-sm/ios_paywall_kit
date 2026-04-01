//
//  STPaywallDetailFeatureCell.swift
//  STPaywallUIKit
//

import SnapKit
import UIKit

final class STPaywallDetailFeatureCell: UITableViewCell {
    deinit { }

    // MARK: - UI Components

    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = STPaywallColors.contentBackground
        view.layer.cornerRadius = STPaywallRadius.lg
        return view
    }()

    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 12
        stack.alignment = .center
        return stack
    }()

    private lazy var iconContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = STPaywallColors.primary.withAlphaComponent(0.1)
        view.layer.cornerRadius = 20
        return view
    }()

    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = STPaywallColors.primary
        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = STPaywallTypography.bodyBold
        label.textColor = STPaywallColors.textPrimary
        label.numberOfLines = 1
        return label
    }()

    private lazy var checkmarkView: UIView = {
        let view = UIView()
        view.backgroundColor = STPaywallColors.success.withAlphaComponent(0.15)
        view.layer.cornerRadius = 10
        return view
    }()

    private lazy var checkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "checkmark")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = STPaywallColors.success
        return imageView
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
        self.containerView.addSubview(self.stackView)

        self.iconContainerView.addSubview(self.iconImageView)
        self.checkmarkView.addSubview(self.checkImageView)

        self.stackView.addArrangedSubview(self.iconContainerView)
        self.stackView.addArrangedSubview(self.titleLabel)
        self.stackView.addArrangedSubview(self.checkmarkView)

        self.containerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.bottom.equalToSuperview().inset(4)
        }

        self.stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(12)
        }

        self.iconContainerView.snp.makeConstraints { make in
            make.size.equalTo(40)
        }

        self.iconImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(20)
        }

        self.checkmarkView.snp.makeConstraints { make in
            make.size.equalTo(20)
        }

        self.checkImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(12)
        }
    }

    // MARK: - Configuration

    func configure(with viewModel: STPaywallDetailFeatureViewModel) {
        self.iconImageView.image = UIImage(systemName: viewModel.iconName)
        self.titleLabel.text = viewModel.title
    }
}
