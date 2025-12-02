//
//  SceneDelegate.swift
//  StatApp
//
//  Created by Илья Лощилов on 02.12.2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)

        let statisticsVC = StatisticsViewController()
        let nav = UINavigationController(rootViewController: statisticsVC)
        nav.navigationBar.prefersLargeTitles = true

        window.rootViewController = nav
        self.window = window
        window.makeKeyAndVisible()
    }
}
