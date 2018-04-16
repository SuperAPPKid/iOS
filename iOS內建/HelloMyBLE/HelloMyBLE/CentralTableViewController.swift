//
//  CentralTableViewController.swift
//  HelloMyBLE
//
//  Created by user37 on 2018/3/22.
//  Copyright © 2018年 user37. All rights reserved.
//

import UIKit
import CoreBluetooth

class CentralTableViewController: UITableViewController,CBCentralManagerDelegate,CBPeripheralDelegate {

    var manager:CBCentralManager?
    var allItems:[String:Device] = [:]
    var lastRefreshDate = Date()
    var restServices:[CBService]?
    var info = ""
    let targetUUIDString = "FFE1"
    var shouldTalking = false
    var talkingCharateristic:CBCharacteristic?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager = CBCentralManager.init(delegate: self, queue: DispatchQueue.global())
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if talkingCharateristic != nil {
            guard let peripheral = talkingCharateristic?.service.peripheral else {
                assertionFailure()
                return
            }
            if peripheral.state == .connected {
                manager?.cancelPeripheralConnection(peripheral)
            }
            talkingCharateristic = nil
        }
    }

    @IBAction func toogleSwitch(_ sender: UISwitch) {
        if sender.isOn {
            //start scan
           startScan()
        } else {
            //stop scan
            stopScan()
        }
    }
    
    func startScan() {
//        let uuid1 = CBUUID.init(string: "1234")
//        let uuid2 = CBUUID.init(string: "5678")
//        let uuids = [uuid1,uuid2]
        let options = [CBCentralManagerScanOptionAllowDuplicatesKey:true]
//        manager?.scanForPeripherals(withServices: uuids, options: options)
        manager?.scanForPeripherals(withServices: nil, options: options)
    }
    
    func stopScan() {
        manager?.stopScan()
    }
    
    func showAlert(_ str:String) {
        let message = "NO BLE: \(str)"
        let alert = UIAlertController.init(title: nil, message: message, preferredStyle: .alert)
        let ok = UIAlertAction.init(title: "ok", style: .cancel, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allItems.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        guard let item = getDeviceBy(indexPath: indexPath) else {
            assertionFailure()
            return cell
        }
        let name = item.peripheral.name ?? "NoName"
        let lastSeenSeconds = String(format:"%.1f",Date().timeIntervalSince(item.lastSeenDate))
        
        cell.textLabel?.text = "\(name) RSSI: \(item.rssi)"
        cell.detailTextLabel?.text = "Last Seen: \(lastSeenSeconds) seconds ago"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        shouldTalking = false
        connectToDevice(indexPath)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        shouldTalking = true
        connectToDevice(indexPath)
    }
    
    func getDeviceBy (indexPath:IndexPath) -> Device? {
        let allKeys = Array.init(allItems.keys)
        let key = allKeys[indexPath.row]
        return allItems[key]
    }
    
    func connectToDevice(_ indexPath:IndexPath) {
        guard let item = getDeviceBy(indexPath: indexPath) else {
            assertionFailure()
            return
        }
        manager?.connect(item.peripheral, options: nil)
    }
    
    // MARK: - CBCentralManagerDelegate
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        let state = central.state
        if state != .poweredOn {
            showAlert("\(state.rawValue)")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        let identifier = peripheral.identifier.uuidString
        let existItem = allItems[identifier]
        
        if existItem == nil {
            let name = peripheral.name ?? "No Name"
            print("found: \(name)","ID: \(peripheral.identifier)","RSSI: \(RSSI)" ,"AdData: \(advertisementData)" )
        }
        
        let now = Date()
        let newItem = Device.init(peripheral: peripheral, rssi: RSSI.intValue, lastSeenDate: now)
        allItems[identifier] = newItem
        
        if now.timeIntervalSince(lastRefreshDate) > 1.0 || existItem == nil {
            lastRefreshDate = now
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("OK...\(peripheral.identifier)")
        stopScan()
        
        peripheral.delegate = self
        peripheral.discoverServices(nil) //拿到peripheral的裝置
    }
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        startScan()
    }
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        
    }
    
    // MARK: - CBPeripheralDelegate
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let err = error {
            showAlert("DiscoverServices error: \(err)")
            manager?.cancelPeripheralConnection(peripheral)
            return
        }
        info = "*** Peripheral: \(peripheral.name ?? "(NoName)") \(peripheral.services?.count ?? 0) \n"
        
        restServices = peripheral.services
        discoverNextService(of: peripheral)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let err = error {
            showAlert("DiscoverServices error: \(err)")
            manager?.cancelPeripheralConnection(peripheral)
            return
        }
        
        guard let characteristics = service.characteristics else {
            assertionFailure()
            return
        }
        
        info += "**Service: \(service.uuid)\(characteristics.count)\n"
        
        for tmp in characteristics {
            info += "* Char: \(tmp.uuid)\n"
            
            if shouldTalking && tmp.uuid.uuidString == targetUUIDString {
                talkingCharateristic = tmp
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "goTalking", sender: nil)
                }
                return
            }
        }
        
        if let restServiceCount = restServices?.count, restServiceCount > 0 {
            discoverNextService(of: peripheral)
        } else {
            showAlert(info)
            manager?.cancelPeripheralConnection(peripheral)
        }
        
    }
    
    func discoverNextService(of peripheral:CBPeripheral) {
        guard let nextService = restServices?.first else {
            return
        }
        restServices?.removeFirst()
        peripheral.discoverCharacteristics(nil, for: nextService)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? TalkingViewController {
            vc.targetCharacteristic = talkingCharateristic
        }
    }
    
}

struct Device {
    let peripheral:CBPeripheral
    let rssi:Int
    let lastSeenDate:Date
}
