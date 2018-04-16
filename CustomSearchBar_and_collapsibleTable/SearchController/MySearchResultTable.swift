//
//  SearchTableControllerViewController.swift
//  SearchController
//
//  Created by zhong on 2018/4/8.
//  Copyright © 2018年 zhong. All rights reserved.
//

import UIKit

class MySearchResultTable: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var myResultData = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
    }

}
extension MySearchResultTable: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myResultData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = myResultData[indexPath.row]
        return cell
    }
}
