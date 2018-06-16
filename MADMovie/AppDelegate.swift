//
//  AppDelegate.swift
//  MADMovie
//
//  Copyright © 2018 marydort. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var appNavigator: AppNavigator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        self.configureNavigationBarAppearace()
        
        let rootViewController = UINavigationController()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = rootViewController
        appNavigator = AppNavigator(navigationController: rootViewController)
        appNavigator?.navigate(to: .MoviesList)
        window?.makeKeyAndVisible()
        
        return true
    }
    
    private func configureNavigationBarAppearace() {
        let navigationBarAppearace = UINavigationBar.appearance()

        navigationBarAppearace.barStyle = .black
        navigationBarAppearace.tintColor = UIColor.red
        navigationBarAppearace.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.red, NSAttributedStringKey.font: UIFont(name: "AmericanTypewriter-Bold", size: 25)!]
        navigationBarAppearace.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.red, NSAttributedStringKey.font: UIFont(name: "AmericanTypewriter-Bold", size: 30)!]
    }
}
