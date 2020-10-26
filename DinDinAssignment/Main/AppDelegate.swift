//
//  AppDelegate.swift
//  DinDinAssignment
//
//  Created by Aman on 23/10/20.
//  Copyright © 2020 Aman. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Create view controller
        let dishController = DishListRouter.createController()

        // Initiating instance of Navigation controller with child controller
        let navigationController = UINavigationController()
        navigationController.navigationBar.isHidden = true
        navigationController.viewControllers = [dishController]

        // Setting up the root view-controller with navigationn controller
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        return true
    }

}

