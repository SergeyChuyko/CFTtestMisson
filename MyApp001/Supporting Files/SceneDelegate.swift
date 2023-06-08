import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let defaults = UserDefaults.standard
        let isRegistered = defaults.bool(forKey: "isRegistered")
        
        print("Is registered: \(isRegistered)")
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initialViewController: UIViewController
        
        if isRegistered {
            initialViewController = storyboard.instantiateViewController(withIdentifier: "SecondViewController")
        } else {
            initialViewController = storyboard.instantiateViewController(withIdentifier: "ViewController")
        }
        
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = initialViewController
        window?.makeKeyAndVisible()
    }



    func sceneDidDisconnect(_ scene: UIScene) {}

    func sceneDidBecomeActive(_ scene: UIScene) {}

    func sceneWillResignActive(_ scene: UIScene) {}

    func sceneWillEnterForeground(_ scene: UIScene) {}

    func sceneDidEnterBackground(_ scene: UIScene) {}
   

    


}

