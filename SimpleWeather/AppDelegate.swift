//swiftlint:disable line_length
//
//  AppDelegate.swift
//  SimpleWeather
//
//  Created by Luthfi Fathur Rahman on 07/04/20.
//  Copyright © 2020 luthfifr. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        if #available(iOS 13.0, *) {
            //should do nothing
        } else {
            let firstVC = SWViewController()
            let navVC = UINavigationController.init(rootViewController: firstVC)
            navVC.navigationBar.layer.shadowOpacity = 0.3
            navVC.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 1)
            navVC.navigationBar.layer.shadowRadius = 5
            navVC.navigationBar.layer.masksToBounds = false
            window = UIWindow(frame: UIScreen.main.bounds)
            window?.backgroundColor = .clear
            window?.rootViewController = navVC
            window?.makeKeyAndVisible()
        }
        return true
    }
}

// MARK: - UISceneSession Lifecycle
@available(iOS 13, *)
extension AppDelegate {
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}
