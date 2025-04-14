
import UIKit
import mParticle_Apple_SDK

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        if let key = ProcessInfo.processInfo.environment["MPARTICLE_KEY"],
           let secret = ProcessInfo.processInfo.environment["MPARTICLE_SECRET"] {
            MParticle.sharedInstance().start(with: MParticleOptions(key: key, secret: secret))
        }

        window = UIWindow()
        window?.rootViewController = HomeViewController()
        window?.makeKeyAndVisible()
        return true
    }
}
