//
//  TodayViewController.swift
//  WidgetTempMap
//
//  Created by user37 on 2018/3/12.
//  Copyright © 2018年 user37. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    @IBOutlet weak var image: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.extensionContext?.widgetLargestAvailableDisplayMode = .expanded
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        if activeDisplayMode == .compact {
            self.preferredContentSize = CGSize.init(width: 10, height: 10)
        } else {
            self.preferredContentSize = CGSize.init(width: 320, height: 320)
        }
    }
    
    @IBAction func refresh(_ sender: UIButton) {
        refreshTempMap(completionHandler: nil)
    }
    @IBAction func launch(_ sender: UIButton) {
        guard let url = URL.init(string: "TempMAPD22://banana") else {
            assertionFailure("OMG")
            return
        }
        self.extensionContext?.open(url, completionHandler: { (result) in
            print("Result is :" + (result ? "true":"false"))
        })
    }
    func refreshTempMap (completionHandler: ((NCUpdateResult) -> Void)?) {
        guard let url = URL.init(string: "https://www.cwb.gov.tw/V7/observe/real/Data/Real_Image.png?dumm=1520834239") else {
            assertionFailure("Invalid url.")
            completionHandler?(.failed)
            return
        }
        let config = URLSessionConfiguration.default
        let session = URLSession.init(configuration: config)
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print(error)
                return
            }
            guard let data = data else{
                assertionFailure("data never be nill")
                return
            }
            let image = UIImage.init(data: data)
            DispatchQueue.main.async {
                self.image.image = image
            }
            completionHandler?(.newData)
        }
        task.resume()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        refreshTempMap(completionHandler: completionHandler)
    }
    
}
