//
//  AppDelegate.swift
//  shirkers-challenge
//
//  Created by Artur Carneiro on 10/07/19.
//  Copyright © 2019 Artur Carneiro. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // Override point for customization after application launch.

        /// Initialization of each page for the `UIPageViewController`.
        let firstPage = SettingsViewController()
        let secondPage = InboxViewController()
        let thirdPage = ArchiveViewController()

        let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)

        /// Initialization of the `RootPageViewController` and `MemoraNavigationViewController`
        let rootPageViewController = RootPageViewController(pages: [firstPage, secondPage, thirdPage],
                                                            pageViewController: pageViewController)
        let memoraNavigationViewController = MemoraNavigationViewController(rootViewController: rootPageViewController)

        /// Initialization of the PlayerComponentViewController
        let playerComponentViewController = PlayerComponentViewController()

        window = UIWindow(frame: UIScreen.main.bounds)
        if let window = window {
            window.rootViewController = RootViewController(memoraNavigationViewController: memoraNavigationViewController ,
                                                           playerComponentViewController: playerComponentViewController)
            window.makeKeyAndVisible()
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {

    }

    func applicationDidEnterBackground(_ application: UIApplication) {

    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }
}
