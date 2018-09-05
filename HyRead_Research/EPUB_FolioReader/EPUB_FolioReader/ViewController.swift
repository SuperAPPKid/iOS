//
//  ViewController.swift
//  EPUB_FolioReader
//
//  Created by Hank_Zhong on 2018/9/5.
//  Copyright © 2018年 Hank_Zhong. All rights reserved.
//

import UIKit
import GCDWebServer
class ViewController: UIViewController {
    var webUploader: GCDWebUploader!
    var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let serverSwitch = UISwitch()
        serverSwitch.center = CGPoint(x: 100, y: 100)
        serverSwitch.isOn = false
        serverSwitch.addTarget(self, action: #selector(toogleServer(sender:)), for: .valueChanged)
        navigationItem.title = "Server 關閉中"
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: serverSwitch)
        
        let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? NSHomeDirectory() + "/Documents"
        webUploader = GCDWebUploader(uploadDirectory: documentPath)
        
        label = UILabel(frame: CGRect(x: 50, y: 75, width: 300, height: 50))
        label.text = "URL:???"
        view.addSubview(label)
    }
    
    @objc func toogleServer(sender: UISwitch) {
        if sender.isOn {
            webUploader.start()
            navigationItem.title = "Server 開啟中"
            label?.text = "URL : \(webUploader?.serverURL?.absoluteString ?? "???")"
        } else {
            webUploader?.stop()
            navigationItem.title = "Server 關閉中"
            label?.text = "URL : ???"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

