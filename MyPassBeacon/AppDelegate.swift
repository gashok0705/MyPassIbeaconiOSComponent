//
//  AppDelegate.swift
//  MyPassBeacon
//
//  Created by Rajagopal Ganesan on 24/09/19.
//  Copyright © 2019 Rajagopal Ganesan. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let types = UIUserNotificationType(rawValue:UIUserNotificationType.alert.rawValue | UIUserNotificationType.sound.rawValue | UIUserNotificationType.badge.rawValue)
        
        application.registerUserNotificationSettings(UIUserNotificationSettings(types: types, categories: nil))
        
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
    
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        
        
    }
    func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, for notification: UILocalNotification, completionHandler: @escaping () -> Void) {
        
    }
    
    
    func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, for notification: UILocalNotification, withResponseInfo responseInfo: [AnyHashable : Any], completionHandler: @escaping () -> Void) {
        
    }
    
    //    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
    //        print("monitoringDidFailFor")
    //        print(error)
    //    }
    //
    //    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    //        print("didFailWithError")
    //        print(error)
    //    }
    //
    //        func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
    //            manager.startRangingBeacons(in: region as! CLBeaconRegion)
    //            manager.startUpdatingLocation()
    //            print("control in didEnterRegion")
    //
    //        }
    //
    //        func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
    //            manager.stopRangingBeacons(in: region as! CLBeaconRegion)
    //            manager.stopUpdatingLocation()
    //            print("control in didExitRegion")
    //
    //        }
    //
    //        func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
    //
    //            print("control in didrangebeacons \(beacons.count)")
    //
    //            if beacons.count > 0 {
    //                updateDistance(beacons[0].proximity)
    //            } else {
    //                updateDistance(.unknown)
    //            }
    //        }
    
    
}

