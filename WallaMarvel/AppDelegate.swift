import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        #if DEBUG
        setupStubs()
        #endif
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    private func setupStubs() {
        let mockData = MockData()
        if ProcessInfo.processInfo.arguments.contains("ENABLE_STUBS") {
            mockData.setupStubs()
        } else if ProcessInfo.processInfo.arguments.contains("ENABLE_STUBS_ERROR") {
            mockData.setupErrorStubs()
        }
    }
}
