//
//  AppDelegate.swift
//  GameLibrary
//
//  Created by Hakan Kumdakçı on 8.04.2022.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let window = UIWindow()
        window.rootViewController = TabBarViewController()
        window.makeKeyAndVisible()
        
        if #available(iOS 13.0, *) {
            window.overrideUserInterfaceStyle = .light
        }
        
        self.window = window
        
        return true
    }
}

