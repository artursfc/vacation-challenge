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
import os.log

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // Core Data stack init
        let coreDataStack = CoreDataStack(model: "shirkers_challenge")

        // Notification Request
        let uncenter = UNUserNotificationCenter.current()

        uncenter.requestAuthorization(options: [.alert, .sound]) { (success, failure) in
            if success {
                os_log("User accepted notification request.", log: .appFlow, type: .debug)
            } else {
                os_log("User denied notification request.", log: .appFlow, type: .debug)
            }
        }
        // Initialization of each page for the `UIPageViewController`.
        // First Page
        let firstPage = SettingsViewController()

        // Second Page
        let secondPageViewModel = InboxViewModel(context: coreDataStack.mainContext)
        let secondPage = InboxViewController(viewModel: secondPageViewModel)

        // Third Page
        let thirdPageViewModel = ArchiveViewModel(context: coreDataStack.mainContext)
        let thirdPage = ArchiveViewController(viewModel: thirdPageViewModel)

        let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)

        // Initialization of the `RootPageViewController` and `MemoraNavigationViewController`
        let rootPageViewController = RootPageViewController(pages: [firstPage, secondPage, thirdPage],
                                                            pageViewController: pageViewController,
                                                            context: coreDataStack.mainContext)
        let memoraNavigationViewController = MemoraNavigationViewController(rootViewController: rootPageViewController)

        // Initialization of the PlayerComponentViewController
        let playerComponentViewModel = PlayerComponentViewModel()
        let playerComponentViewController = PlayerComponentViewController(viewModel: playerComponentViewModel)

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
