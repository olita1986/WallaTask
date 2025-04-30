import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        
        let heroCoordinator = HeroCoordinator()
        heroCoordinator.start()
        window.rootViewController = heroCoordinator.rootViewController
        self.window = window
        self.window?.makeKeyAndVisible()
    }
}

