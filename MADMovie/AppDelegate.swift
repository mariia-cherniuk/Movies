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
    private var appNavigator: AppNavigator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        self.configureNavigationBarAppearace()
        
        let rootViewController = UINavigationController()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = rootViewController
        appNavigator = AppNavigator(navigationController: rootViewController)
        appNavigator?.navigate(to: .moviesList)
        window?.makeKeyAndVisible()
        
        return true
    }
    
    private func configureNavigationBarAppearace() {
        let navigationBarAppearace = UINavigationBar.appearance()
        let barButtonItemAppearance = UIBarButtonItem.appearance()

        barButtonItemAppearance.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.clear], for: .normal)
        barButtonItemAppearance.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.clear], for: UIControl.State.highlighted)
        
        navigationBarAppearace.barStyle = .black
        navigationBarAppearace.tintColor = UIColor.red
        navigationBarAppearace.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.red, NSAttributedString.Key.font: UIFont(name: "AmericanTypewriter-Bold", size: 25)!]
        navigationBarAppearace.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.red, NSAttributedString.Key.font: UIFont(name: "AmericanTypewriter-Bold", size: 30)!]
    }
}
