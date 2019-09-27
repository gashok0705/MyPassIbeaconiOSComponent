//
//  ViewController.swift
//  MyPassBeacon
//
//  Created by Rajagopal Ganesan on 24/09/19.
//  Copyright © 2019 Rajagopal Ganesan. All rights reserved.
//

import UIKit
import CoreLocation
import UserNotifications

class ViewController: UIViewController {
    
    @IBOutlet weak var beaconStatusLabel: UILabel!
    @IBOutlet weak var settingsButton: UIButton!
    var locationManager: CLLocationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.requestNotifications()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.setUpLocationManager()
    }
    
    private func requestNotifications() {
        if #available(iOS 10.0, *) {
            let notificationCenter = UNUserNotificationCenter.current()
            let options: UNAuthorizationOptions = [.alert, .sound, .badge]
            
            notificationCenter.requestAuthorization(options: options) { (granted, error) in
                // Enable or disable features based on authorization.
                if granted {
                    print("User granted user notification!!")
                    self.scheduleNotifications(title: "Hey", messageBody: "testNotification")
                } else {
                    print("User denied user notifications!!")
                }
            }
        } else {
            // Fallback on earlier versions
            //print("control is here..")
            //self.pushLocalNotification(title: "Hey", messageBody: "testNotifications")
        }

    }
    
    
    private func pushLocalNotification(title: String, messageBody: String) {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
            let center = UNUserNotificationCenter.current()
            center.removeAllPendingNotificationRequests()
            center.removeAllDeliveredNotifications()
            
            let content = UNMutableNotificationContent()
            content.title = title
            content.body = messageBody
            content.categoryIdentifier = "alarm"
            content.sound = UNNotificationSound.default
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
            
            //let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            let notificationRequest = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            
            // Add Request to User Notification Center
            UNUserNotificationCenter.current().add(notificationRequest) { (error) in
                if let error = error {
                    print("Unable to Add Notification Request (\(error), \(error.localizedDescription))")
                }
            }
        } else {
            // Fallback on earlier versions
            let notification = UILocalNotification()
            notification.fireDate = NSDate(timeIntervalSinceNow: 1) as Date
            notification.alertBody = messageBody
            notification.alertAction = title
            notification.soundName = UILocalNotificationDefaultSoundName
            UIApplication.shared.scheduleLocalNotification(notification)
        }
    }
    
    private func scheduleNotifications(title: String, messageBody: String) {
        if #available(iOS 10.0, *) {
            
            UNUserNotificationCenter.current().getNotificationSettings { (settings) in
                if settings.authorizationStatus == .authorized {
                    // Notifications are allowed
                    self.pushLocalNotification(title: title, messageBody: messageBody)
                }
                else {
                    // Either denied or notDetermined
                    self.directUserToSettings(alertMessage: PushNotificationMessage)
                }
            }
        } else {
//            let isRegisteredForRemoteNotifications = UIApplication.shared.isRegisteredForRemoteNotifications
//            if isRegisteredForRemoteNotifications {
//                self.pushLocalNotification(title: title, messageBody: messageBody)
//            } else {
//                // Either denied or notDetermined
//                self.directUserToSettings(alertMessage: PushNotificationMessage)
//            }
            self.pushLocalNotification(title: title, messageBody: messageBody)
        }
        
    }

    
    @IBAction func settingsButtonTapped(_ sender: UIButton) {
        self.directUserToSettings(alertMessage: AlertMessage)
    }
    
    private func setUpLocationManager() {
        self.locationManager.delegate = self
        self.locationManager.requestAlwaysAuthorization()
        
    }
    
    private func startScanning() {
        let uuid = UUID(uuidString: "2b4efa63-4ce6-4f09-aa07-cbcf233f2235")!
        let beaconRegion = CLBeaconRegion(proximityUUID: uuid, major: 789, minor: 132, identifier: "mypassbeacon2")
        self.locationManager.allowsBackgroundLocationUpdates = true
        self.locationManager.pausesLocationUpdatesAutomatically = false
        self.locationManager.startMonitoring(for: beaconRegion)
        self.locationManager.startRangingBeacons(in: beaconRegion)
        self.locationManager.startUpdatingLocation()
        
    }
    
    private func updateDistance(_ distance: CLProximity) {

        print("control in updatedistance")
        UIView.animate(withDuration: 0.8) {
            switch distance {
            case .unknown:
                self.beaconStatusLabel.text = "Unknown"
                //self.scheduleNotifications(title: "Unknown", messageBody: "... ... ...")
                self.view.backgroundColor = UIColor.gray
            case .far:
                self.beaconStatusLabel.text = BeaconFar
                self.scheduleNotifications(title: "Far", messageBody: BeaconFar)
                self.view.backgroundColor = UIColor.blue

            case .near:
                self.beaconStatusLabel.text = BeaconNear
                self.scheduleNotifications(title: "Near", messageBody: BeaconNear)
                self.view.backgroundColor = UIColor.orange

            case .immediate:
                self.beaconStatusLabel.text = BeaconImmediate
                self.scheduleNotifications(title: "Too Close", messageBody: BeaconImmediate)
                self.view.backgroundColor = UIColor.red
            @unknown default:
                self.beaconStatusLabel.text = "Unknown"
                print("No matching distance found \(distance)")
            }
        }
    }
    
    private func directUserToSettings(alertMessage: String) {
        
        let alertController = UIAlertController (title: "Alert", message: alertMessage, preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
            
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                        print("Settings opened: \(success)") // Prints true
                    })
                } else {
                    // Fallback on earlier versions
                    UIApplication.shared.openURL(settingsUrl)
                }
            }
        }
        alertController.addAction(settingsAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alertController.addAction(cancelAction)
        if presentedViewController == nil {
            self.present(alertController, animated: true, completion: nil)
        } else{
            self.dismiss(animated: false) {
                self.present(alertController, animated: true, completion: nil)
            }
        }
        
    }
}

extension ViewController: CLLocationManagerDelegate, UNUserNotificationCenterDelegate {
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {

        switch status {
        case .denied:
            print("user denied the permission")
            self.directUserToSettings(alertMessage: AlertMessage)

        case .notDetermined:
            print("location permission not determined")
            //self.directUserToSettings(alertMessage: AlertMessage)

        case .restricted:
            print("location permission restricted")
            self.directUserToSettings(alertMessage: AlertMessage)

        case .authorizedWhenInUse:
            print("location permission given authorizedwheninuse")
            self.directUserToSettings(alertMessage: AlertMessageForInUse)

        case .authorizedAlways:
            print("location permission granted")
            DispatchQueue.main.async { [weak self] in
                if let strongSelf = self {
                    strongSelf.settingsButton.isHidden = true
                    if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                        if CLLocationManager.isRangingAvailable() {
                            strongSelf.startScanning()
                            return
                        }
                    } else {
                        print("No location found")
                    }
                }
            }

        default:
            print("Nothing matched!!")
        }
        self.settingsButton.isHidden = false

    }

    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        print("The monitored regions are: \(manager.monitoredRegions)")
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
    }

    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        print("control inside state")
    }

    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        manager.startRangingBeacons(in: region as! CLBeaconRegion)
        manager.startUpdatingLocation()
        print("control in didEnterRegion")

    }

    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        manager.stopRangingBeacons(in: region as! CLBeaconRegion)
        manager.stopUpdatingLocation()
        print("control in didExitRegion")

    }

    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {

        print("control in didrangebeacons \(beacons.count)")

        if beacons.count > 0 {
            updateDistance(beacons[0].proximity)
        } else {
            updateDistance(.unknown)
        }
    }

}

