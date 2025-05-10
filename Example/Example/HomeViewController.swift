
import UIKit
import Rokt_Widget
import mParticle_Apple_SDK

class HomeViewController: UIViewController {

    private enum Constants {
        static let buttonHeight: CGFloat = 50
        static let padding: CGFloat = 32
    }

    private lazy var displayButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = .appColor
        configuration.baseForegroundColor = .white
        configuration.buttonSize = .large
        configuration.cornerStyle = .capsule
        configuration.title = "Show"
        button.configuration = configuration
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fill
        return stackView
    }()

    private lazy var imageView: UIView = {
        let containerView = UIView()

        let imageView = UIImageView(image: UIImage(named: "RoktLogo"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.setContentHuggingPriority(.required, for: .horizontal)
        containerView.addSubview(imageView)

        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(greaterThanOrEqualTo: containerView.leadingAnchor),
            imageView.trailingAnchor.constraint(lessThanOrEqualTo: containerView.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            imageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 200)
        ])
        return containerView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Seize the Transaction Moment"
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textAlignment = .center
        label.textColor = .titleColor
        return label
    }()

    private let captionLabel: UILabel = {
        let label = UILabel()
        label.text = "® Rokt 2025 — All rights reserved"
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .textColor
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let spacer: UIView = {
        let view = UIView()
        view.setContentHuggingPriority(.defaultLow, for: .vertical)
        view.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        return view
    }()

    private lazy var roktEmbeddedView: RoktEmbeddedView = RoktEmbeddedView()

    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        indicator.isHidden = true
        indicator.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(indicator)
        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        return indicator
    }()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = .white
        view.addSubview(stackView)
        view.addSubview(captionLabel)

        [
            imageView,
            titleLabel,
            spacer,
            displayButton,
            roktEmbeddedView
        ].forEach { stackView.addArrangedSubview($0) }

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.padding),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.padding),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.padding),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: captionLabel.topAnchor),

            captionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.padding),
            captionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.padding),
            captionLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            displayButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: Constants.padding),
        ])
    }

    @objc private func buttonTapped() {
        let attributes = [
            "email": "j.smith@example.com",
            "firstname": "Jenny",
            "lastname": "Smith",
            "mobile": "(555)867-5309",
            "postcode": "90210",
            "country": "US"
        ]

        MParticle
            .sharedInstance()
            .rokt
            .selectPlacements(
                "RoktEmbeddedExperience",
                attributes: attributes,
                placements: ["RoktEmbedded1": roktEmbeddedView],
                onLoad: {
                    // Optional callback for when the Rokt placement loads
                },
                onUnLoad: { [weak self] in
                    // Optional callback for when the Rokt placement unloads
                    self?.hideButton(false)
                },
                onShouldShowLoadingIndicator: { [weak self] in
                    // Optional callback to show a loading indicator
                    self?.loadingIndicator.startAnimating()
                },
                onShouldHideLoadingIndicator: { [weak self] in
                    self?.loadingIndicator.stopAnimating()
                },
                onEmbeddedSizeChange: { selectedPlacement, widgetHeight in
                    // Optional callback to get selectedPlacement and height required by the placement every time the height of the placement changes
                }
            )
        hideButton(true)
    }

    private func hideButton(_ hide: Bool) {
        roktEmbeddedView.isHidden = !hide
        displayButton.isHidden = hide
        spacer.isHidden = hide
    }
}
