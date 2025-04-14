
import mParticle_Apple_SDK
import Rokt_Widget
import SwiftUI
import SafariServices
import UIKit

class SampleViewController: UIViewController {

    private lazy var roktEmbeddedView: RoktEmbeddedView = {
        let roktView = RoktEmbeddedView()
        roktView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(roktView)
        NSLayoutConstraint.activate([
            roktView.topAnchor.constraint(equalTo: view.topAnchor),
            roktView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            roktView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            roktView.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor)
        ])
        return roktView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }

    @objc func setup() {
        view.backgroundColor = .white

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
                    self?.dismiss(animated: true)
                },
                onShouldShowLoadingIndicator: {
                    // Optional callback to show a loading indicator
                },
                onShouldHideLoadingIndicator: {
                    // Optional callback to hide a loading indicator
                },
                onEmbeddedSizeChange: { selectedPlacement, widgetHeight in
                    // Optional callback to get selectedPlacement and height required by the placement every time the height of the placement changes
                }
            )
    }
}
