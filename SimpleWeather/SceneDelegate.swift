//
//  SceneDelegate.swift
//  SimpleWeather
//
//  Created by Luthfi Fathur Rahman on 07/04/20.
//  Copyright © 2020 luthfifr. All rights reserved.
//

import UIKit
@available(iOS 13, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = scene as? UIWindowScene else { return }
        let window = UIWindow(windowScene: windowScene)
        let firstVC = SWViewController()

        let navigation = UINavigationController(rootViewController: firstVC)
        window.rootViewController = navigation

        self.window = window
        window.makeKeyAndVisible()
    }
}

