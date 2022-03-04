//
//  SceneDelegate.swift
//  irish-rail
//
//  Created by Bruno Diniz on 26/02/2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var coordinator: AppCoordinator?
    
    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        let tabBarController = UITabBarController()
        coordinator = AppCoordinator(tabBarController: tabBarController)
        coordinator?.start()
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        StorageManagerBase.shared.loadStorage()
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        StorageManagerBase.shared.commitStorage()
    }

}
