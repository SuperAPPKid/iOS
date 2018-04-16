//
//  SecondViewController.swift
//  HelloMyBLE
//
//  Created by user37 on 2018/3/22.
//  Copyright © 2018年 user37. All rights reserved.
//

import UIKit
import CoreBluetooth
class PeripheralViewController: UIViewController,CBPeripheralManagerDelegate {
    
    let serviceUUID = CBUUID.init(string: "8886")
    let characteristicUUID = CBUUID.init(string: "8888")
    let chatroomName = "聊天室"
    
    var manager:CBPeripheralManager!
    var mainCharacteristic:CBMutableCharacteristic!
    var resendBuffer = ""
    
    @IBOutlet weak var inputTextfield: UITextField!
    @IBOutlet weak var logTextView: UITextView!
    
    @IBAction func send(_ sender: UIBarButtonItem) {
        guard let text = inputTextfield.text else {
            return
        }
        guard text.count > 0 else {
            return
        }
        inputTextfield.resignFirstResponder()
        
        let message = "[\(chatroomName)]\(text)\n"
        sendMessage(message, central: nil)
        logTextView.text! += message
    }
    
    @IBAction func toggleOnOff(_ sender: UISwitch) {
        if sender.isOn {
            startNotify()
        } else {
            stopNotify()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.manager = CBPeripheralManager.init(delegate: self, queue: nil)
    }
    
    func startNotify() {
        if mainCharacteristic == nil {
            
            let properties:CBCharacteristicProperties = [.notify,.read,.write]
            let permissions:CBAttributePermissions = [.readable,.writeable]
            mainCharacteristic = CBMutableCharacteristic.init(type: characteristicUUID, properties: properties, value: nil, permissions: permissions)
            
            let service = CBMutableService.init(type: serviceUUID, primary: true)
            service.characteristics = [mainCharacteristic]
            
            manager?.add(service)
        }
        
        let UUIDs = [serviceUUID]
        let info:[String:Any] = [CBAdvertisementDataLocalNameKey:chatroomName,
                                 CBAdvertisementDataServiceUUIDsKey:UUIDs]
        manager.startAdvertising(info)
    }
    
    func stopNotify() {
        manager.stopAdvertising()
    }
    
    func sendMessage(_ message:String, central:CBCentral?) {
        let centrals = (central == nil ? nil:[central!])
        
        guard let data = message.data(using: .utf8) else {
            return
        }
        
        let success = manager.updateValue(data, for: mainCharacteristic, onSubscribedCentrals: centrals)
        print("SEND MESSAGE: " + (success ? "ok":"ng"))
        
        if success == false {
            resendBuffer += message
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - CBPeripheralManagerDelegate
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        let state = peripheral.state
        if state != .poweredOn {
            print("---NO BLE : \(state.rawValue)")
        }
    }
    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didSubscribeTo characteristic: CBCharacteristic) {
        guard let total = mainCharacteristic.subscribedCentrals?.count else {
            assertionFailure()
            return
        }
        let message = "--- Someone is coming : \(central.identifier), \(central.maximumUpdateValueLength), total:\(total)\n"
        let hello = "-- Welcome to \(chatroomName), total:\(total)\n"
        logTextView.text! += message
        
        sendMessage(hello, central: central)
        sendMessage(message, central: nil)
    }
    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didUnsubscribeFrom characteristic: CBCharacteristic) {
        let message = "-- Someone is Leaving : \(central.identifier), \(central.maximumUpdateValueLength)\n"
        sendMessage(message, central: nil)
        logTextView.text! += message
    }
    func peripheralManagerIsReady(toUpdateSubscribers peripheral: CBPeripheralManager) {
        sendMessage(resendBuffer, central: nil)
        resendBuffer = ""
    }
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveWrite requests: [CBATTRequest]) {
        for request in requests {
            guard let value = request.value else {
                manager.respond(to: request, withResult: .invalidAttributeValueLength)
                continue
            }
            guard let message = String.init(data: value, encoding: .utf8) else {
                manager.respond(to: request, withResult: .requestNotSupported)
                continue
            }
            logTextView.text! += message
            sendMessage(message, central: nil)
            
            manager.respond(to: request, withResult: .success)
        }
    }
}

