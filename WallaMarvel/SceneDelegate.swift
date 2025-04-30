import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private var heroCoordinator = HeroCoordinator()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        
        heroCoordinator.start()
        window.rootViewController = heroCoordinator.rootViewController
        self.window = window
        self.window?.makeKeyAndVisible()
    }
}

