//
//  ContainerViewController.swift
//  Potrait_and_Landscape_and_dynamicCell
//
//  Created by zhong on 2018/7/18.
//  Copyright © 2018年 zhong. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    let data:[String] = ["123456789qwertyuiopasdlkjhgfzxcmnbv",
                         "123456789qwertyuiopasdlkjhgfzxcmnbv123456789qwertyuiopasdlkjhgfzxcmnbv",
                         "123456789qwertyuiopasdlkjhgfzxcmnbv123456789qwertyuiopasdlkjhgfzxcmnbv123456789qwertyuiopasdlkjhgfzxcmnbv123456789qwertyuiopasdlkjhgfzxcmnbv",
                         "123456789qwertyuiopasdlkjhgfzxcmnbv123456789qwertyuiopasdlkjhgfzxcmnbv123456789qwertyuiopasdlkjhgfzxcmnbv123456789qwertyuiopasdlkjhgfzxcmnbv123456789qwertyuiopasdlkjhgfzxcmnbv123456789qwertyuiopasdlkjhgfzxcmnbv",
                         "123456789qwertyuiopasdlkjhgfzxcmnbv123456789qwertyuiopasdlkjhgfzxcmnbv123456789qwertyuiopasdlkjhgfzxcmnbv123456789qwertyuiopasdlkjhgfzxcmnbv123456789qwertyuiopasdlkjhgfzxcmnbv123456789qwertyuiopasdlkjhgfzxcmnbv",
                         "123456789qwertyuiopasdlkjhgfzxcmnbv123456789qwertyuiopasdlkjhgfzxcmnbv",
                         "123456789qwertyuiopasdlkjhgfzxcmnbv123456789qwertyuiopasdlkjhgfzxcmnbv123456789qwertyuiopasdlkjhgfzxcmnbv123456789qwertyuiopasdlkjhgfzxcmnbv123456789qwertyuiopasdlkjhgfzxcmnbv123456789qwertyuiopasdlkjhgfzxcmnbv123456789qwertyuiopasdlkjhgfzxcmnbv123456789qwertyuiopasdlkjhgfzxcmnbv",
                         "123456789qwertyuiopasdlkjhgfzxcmnbv123456789qwertyuiopasdlkjhgfzxcmnbv",]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
}
extension ContainerViewController:UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "custom", for: indexPath) as! TableViewCell
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.label.text = data[indexPath.row]
//        cell.textLabel?.text = data[indexPath.row]
//        cell.textLabel?.numberOfLines = 0
        cell.layoutMargins = UIEdgeInsets(top: 0, left: 200, bottom: 0, right: 100)
        return cell
    }
}
