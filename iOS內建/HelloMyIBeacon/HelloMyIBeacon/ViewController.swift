//
//  ViewController.swift
//  HelloMyIBeacon
//
//  Created by user37 on 2018/3/26.
//  Copyright © 2018年 user37. All rights reserved.
//

import UIKit
import CoreLocation
import UserNotifications
class ViewController: UIViewController,CLLocationManagerDelegate {
    @IBOutlet weak var resultLabel: UILabel!
    let manager = CLLocationManager()
    let beaconUUID = UUID.init(uuidString: "xxxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx")
    
    var beaconRegion:CLBeaconRegion?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager.delegate = self
        manager.requestAlwaysAuthorization()
        
        let center = UNUserNotificationCenter.current()
        let options:UNAuthorizationOptions = [.alert,.badge,.sound]
        center.requestAuthorization(options: options) { (grant, error) in
            print( (grant ? "OK":"NG") )
        }
        
        guard let uuid = beaconUUID else {
            assertionFailure()
            return
        }
        
        beaconRegion = CLBeaconRegion.init(proximityUUID: uuid, identifier: "Beacon")
        beaconRegion?.notifyOnEntry = true
        beaconRegion?.notifyOnExit = true
    }

    @IBAction func toggleOnOf(_ sender: UISwitch) {
        if sender.isOn {
            manager.startMonitoring(for: beaconRegion!)
        } else {
            manager.stopMonitoring(for: beaconRegion!)
        }
    }
    
    //Mark: - CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        let message:String
        if state == .inside {
            message = "User is inside the region: \(region.identifier)"
            manager.startRangingBeacons(in: region as! CLBeaconRegion)
        } else {
            message = "User is outside the region: \(region.identifier)"
            manager.stopRangingBeacons(in: region as! CLBeaconRegion)
        }
        showNotifyToUser(message)
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        for beacon in beacons {
            resultLabel.text = "\(region.identifier),\(beacon.rssi),\(beacon.proximity),\(beacon.accuracy)"
        }
    }
    
    func showNotifyToUser(_ message:String)  {
        guard UIApplication.shared.applicationState != .active else {
            print("App is not in background")
            return
        }
        
        let center = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = "Beacon sstate changed"
        content.body = message
        
        let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 0.5, repeats: false)
        let request = UNNotificationRequest.init(identifier: "Alert", content: content, trigger: trigger)
        
        center.add(request) { (error) in
            print("Request Done...")
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }


}

