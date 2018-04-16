//
//  TalkingViewController.swift
//  HelloMyBLE
//
//  Created by zhong on 2018/3/22.
//  Copyright © 2018年 user37. All rights reserved.
//

import UIKit
import CoreBluetooth

class TalkingViewController: UIViewController,CBPeripheralDelegate {

    @IBOutlet weak var inputField: UITextField!
    @IBOutlet weak var logView: UITextView!
    
    var targetCharacteristic:CBCharacteristic!
    var targetPeripheral:CBPeripheral!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard targetCharacteristic != nil else{
            assertionFailure()
            return
        }
        targetPeripheral = targetCharacteristic.service.peripheral
        targetPeripheral.delegate = self
        
        targetPeripheral.setNotifyValue(true, for: targetCharacteristic)
    }
    
    @IBAction func send(_ sender: UIBarButtonItem) {
        guard let text = inputField.text else {
            return
        }
        guard text.count > 0 else {
            return
        }
        
        inputField.resignFirstResponder()
        
        let content = "[HAN] \(text)\n"
        guard let data = content.data(using: .utf8) else {
            assertionFailure()
            return
        }
        
        let properties = targetCharacteristic.properties
        let type:CBCharacteristicWriteType = properties.contains(.writeWithoutResponse) ? .withoutResponse : .withResponse
        targetPeripheral.writeValue(data, for: targetCharacteristic, type: type)
        //Serial Port RS232
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - CBPeripheralDelegate
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        guard let data = characteristic.value else {
            assertionFailure()
            return
        }
        if let content = String.init(data: data, encoding: .utf8) {
            logView.text! += content
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
