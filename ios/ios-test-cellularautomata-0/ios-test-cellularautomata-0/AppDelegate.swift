//
//  AppDelegate.swift
//  ios-test-cellularautomata-0
//
//  Created by Louie on 8/4/18.
//  Copyright © 2018 Louis Foster. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var mainViewController: MainViewController?
    
    var navController: UINavigationController?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        self.mainViewController = MainViewController()
        
        if let controller = self.mainViewController {
        
            self.navController = UINavigationController(rootViewController: controller)
        }
        
        self.navController?.navigationBar.barTintColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        self.navController?.navigationBar.tintColor = UIColor(red: 0, green: 1, blue: 0, alpha: 1)
        
        self.window?.rootViewController = self.navController
        self.window?.makeKeyAndVisible()
        
        return true
    }
}
