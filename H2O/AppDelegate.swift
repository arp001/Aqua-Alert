//
//  AppDelegate.swift
//  H2O
//
//  Created by Arpit Hamirwasia on 2016-10-29.
//  Copyright © 2016 Arpit. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    
    override init() {
        super.init()
        FIRApp.configure()
        // not really needed unless you really need it FIRDatabase.database().persistenceEnabled = true
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let defaults = UserDefaults.standard
        
        registerLocal()
        
        // set it to the first one of TabBarController to show tabBar
         if defaults.bool(forKey: Constants.didLoginKey) == true {
            let myTabBarController = storyboard.instantiateViewController(withIdentifier: "myTabBarViewController") as! UITabBarController
            self.window?.rootViewController = myTabBarController
            self.window?.makeKeyAndVisible()
        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // MARK: - Notification Methods
    
    func registerLocal() {
        if UserDefaults.standard.bool(forKey: Constants.didAllowNotifKey) {
            return
        }
        
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert,.badge,.sound], completionHandler: {(granted,error) in
            if granted {
                UserDefaults.standard.set(true, forKey: Constants.didAllowNotifKey)
                self.scheduleLocal()
            }
            else {
                UserDefaults.standard.set(false, forKey: Constants.didAllowNotifKey)
            }
        })
        
    }
    
    func scheduleLocal() {
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = "Water Reminder"
        content.body = "It's time to drink a glass of water!"
        content.categoryIdentifier = "notif"
        content.userInfo = ["customData": "fillerInfo"]
        content.sound = UNNotificationSound.default()
        var dateComponents = DateComponents()
        dateComponents.hour = 1
        dateComponents.minute = 0
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
        registerCategories()
    }
    
    func registerCategories() {
        let center = UNUserNotificationCenter.current()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        center.delegate = vc
        let drink = UNNotificationAction(identifier: "drink", title: "Drink", options: .foreground)
        let category = UNNotificationCategory(identifier: "notif", actions: [drink], intentIdentifiers: [])
        center.setNotificationCategories([category])
    }
}

