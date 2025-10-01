//
//  SceneDelegate.swift
//  TaskList
//
//  Created by Альбек Халапов on 28.09.2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.makeKeyAndVisible()
        window?.rootViewController = UINavigationController(rootViewController: TaskListViewController())
    }
    func sceneDidEnterBackground(_ scene: UIScene) {
        StorageManager.shared.saveContext()
    }
}

