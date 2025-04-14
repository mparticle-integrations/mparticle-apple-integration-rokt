
import UIKit

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
        stackView.spacing = 8
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
        label.text = "® Rokt 2024 — All rights reserved"
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .textColor
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = .white
        view.addSubview(stackView)

        [
            imageView,
            titleLabel,
            UIView(),
            displayButton,
            UIView(),
            captionLabel
        ].forEach { stackView.addArrangedSubview($0) }

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.padding),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.padding),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.padding),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Constants.padding),

            displayButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            displayButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),
        ])
    }

    @objc private func buttonTapped() {
        present(SampleViewController(), animated: true)
    }
}
