//
//  SceneDelegate.swift
//  DiffableDataSourceTests
//
//  Created by Marcos Contente on 10/06/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)

        let rootVC = ViewController()
        let nav = UINavigationController(rootViewController: rootVC)

        window.rootViewController = nav
        self.window = window
        window.makeKeyAndVisible()
    }
}
