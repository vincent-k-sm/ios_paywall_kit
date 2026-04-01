//
//  STPaywallDetailProductCell.swift
//  STPaywallUIKit
//

import SnapKit
import UIKit

final class STPaywallDetailProductCell: UITableViewCell {
    deinit { }

    // MARK: - UI Components

    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = STPaywallColors.contentBackground
        view.layer.cornerRadius = 20
        return view
    }()

    private lazy var shadowView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 20
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.08
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 12
        return view
    }()

    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        return stackView
    }()

    private lazy var topContainer: UIView = {
        let view = UIView()
        return view
    }()

    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 26, weight: .bold)
        label.textColor = STPaywallColors.textPrimary
        label.numberOfLines = 0
        label.setContentHuggingPriority(.required, for: .vertical)
        return label
    }()

    private lazy var popularBadge: UIView = {
        let view = UIView()
        view.isHidden = true
        view.layer.addSublayer(self.popularGradientLayer)
        view.addSubview(self.popularBadgeLabel)
        self.popularBadgeLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        return view
    }()

    private lazy var popularBadgeLabel: UILabel = {
        let label = UILabel()
        label.text = "BEST"
        label.font = .systemFont(ofSize: 11, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()

    private lazy var popularGradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [
            UIColor(stHex: "#3182F6").cgColor,
            UIColor(stHex: "#6366F1").cgColor
        ]
        layer.startPoint = CGPoint(x: 0, y: 0.5)
        layer.endPoint = CGPoint(x: 1, y: 0.5)
        layer.cornerRadius = 10
        return layer
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = STPaywallColors.textSecondary
        label.numberOfLines = 0
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        label.setContentHuggingPriority(.required, for: .vertical)
        return label
    }()

    private lazy var promotionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = STPaywallColors.textSecondary
        label.numberOfLines = 0
        label.setContentHuggingPriority(.required, for: .vertical)
        return label
    }()

    private lazy var subscribeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(I18N.detail_btn_subscribe, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .bold)
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(self.subscribeButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var subscribedLabel: UILabel = {
        let label = UILabel()
        label.text = I18N.detail_btn_subscribed
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = STPaywallColors.textTertiary
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()

    // MARK: - Properties

    weak var delegate: STPaywallDetailCellDelegate?
    private var productId: String = ""

    // MARK: - Initialization

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func layoutSubviews() {
        super.layoutSubviews()
        self.popularGradientLayer.frame = self.popularBadge.bounds
        self.shadowView.layer.shadowPath = UIBezierPath(
            roundedRect: self.containerView.bounds,
            cornerRadius: 20
        ).cgPath
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.priceLabel.text = nil
        self.titleLabel.text = nil
        self.promotionLabel.text = nil
        self.promotionLabel.isHidden = true
        self.popularBadge.isHidden = true
        self.subscribedLabel.isHidden = true
        self.subscribeButton.isHidden = false
        self.delegate = nil
        self.productId = ""
    }

    // MARK: - Setup Methods

    private func setupUI() {
        self.selectionStyle = .none
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear

        self.contentView.addSubview(self.shadowView)
        self.contentView.addSubview(self.containerView)
        self.containerView.addSubview(self.mainStackView)
        self.containerView.addSubview(self.subscribeButton)
        self.containerView.addSubview(self.subscribedLabel)

        self.topContainer.addSubview(self.priceLabel)
        self.topContainer.addSubview(self.popularBadge)

        self.mainStackView.addArrangedSubview(self.topContainer)
        self.mainStackView.addArrangedSubview(self.titleLabel)
        self.mainStackView.addArrangedSubview(self.promotionLabel)

        self.shadowView.snp.makeConstraints { make in
            make.edges.equalTo(self.containerView)
        }

        self.containerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.bottom.equalToSuperview().inset(8)
        }

        self.mainStackView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(20)
        }

        self.priceLabel.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview()
            make.trailing.lessThanOrEqualTo(self.popularBadge.snp.leading).offset(-12)
        }

        self.popularBadge.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview()
            make.width.equalTo(50)
            make.height.equalTo(20)
        }

        self.subscribeButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(self.mainStackView.snp.bottom).offset(20)
            make.bottom.equalToSuperview().inset(20)
            make.height.equalTo(48)
        }

        self.subscribedLabel.snp.makeConstraints { make in
            make.center.equalTo(self.subscribeButton)
        }
    }

    // MARK: - Configuration

    func configure(
        with viewModel: STPaywallDetailProductViewModel,
        isPurchased: Bool
    ) {
        self.productId = viewModel.id
        self.priceLabel.text = viewModel.pricePerPeriod
        self.titleLabel.text = viewModel.title
        self.popularBadge.isHidden = !viewModel.isPopular

        if let promotionText = viewModel.promotionText {
            self.promotionLabel.text = promotionText
            self.promotionLabel.isHidden = false
        }
        else {
            self.promotionLabel.isHidden = true
        }

        self.updateStyle(isPurchased: isPurchased, isPopular: viewModel.isPopular)
    }

    // MARK: - Private Methods

    private func updateStyle(isPurchased: Bool, isPopular: Bool) {
        if isPurchased {
            self.containerView.layer.borderWidth = 0
            self.containerView.backgroundColor = STPaywallColors.cardBackground
            self.subscribeButton.isHidden = true
            self.subscribedLabel.isHidden = false
            self.shadowView.layer.shadowOpacity = 0.04
        }
        else if isPopular {
            self.containerView.layer.borderWidth = 2
            self.containerView.layer.borderColor = STPaywallColors.primary.cgColor
            self.containerView.backgroundColor = STPaywallColors.contentBackground
            self.subscribeButton.isHidden = false
            self.subscribedLabel.isHidden = true
            self.subscribeButton.setTitleColor(.white, for: .normal)
            self.subscribeButton.backgroundColor = STPaywallColors.primary
            self.shadowView.layer.shadowOpacity = 0.12
            self.shadowView.layer.shadowColor = STPaywallColors.primary.cgColor
        }
        else {
            self.containerView.layer.borderWidth = 1
            self.containerView.layer.borderColor = STPaywallColors.separator.cgColor
            self.containerView.backgroundColor = STPaywallColors.contentBackground
            self.subscribeButton.isHidden = false
            self.subscribedLabel.isHidden = true
            self.subscribeButton.setTitleColor(STPaywallColors.textPrimary, for: .normal)
            self.subscribeButton.backgroundColor = STPaywallColors.chipBackground
            self.shadowView.layer.shadowOpacity = 0.04
            self.shadowView.layer.shadowColor = UIColor.black.cgColor
        }
    }

    // MARK: - Actions

    @objc private func subscribeButtonTapped() {
        self.delegate?.detailCellDidTapSubscribe(productId: self.productId)
    }
}
