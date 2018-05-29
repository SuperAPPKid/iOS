//
//  TableViewController.swift
//  test
//
//  Created by Hank_Zhong on 2018/5/29.
//  Copyright © 2018年 Hank_Zhong. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    let arrContents:[Int] = [1,2,3,4,5,6,7,8,9,10]
    lazy var arrShow:[Bool] = Array(repeating: false, count: arrContents.count)
    var index:Int {
        return Int(arc4random_uniform(UInt32(arrContents.count)))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(add))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action:  #selector(refresh))
    }
    
    @objc func add(_ sender: UIBarButtonItem) {
        let num = index
        
        arrShow[num] = !arrShow[num]
        
        //guard let cell = tableView.cellForRow(at: IndexPath(row: num, section: 0)) else { return } 試試看
        if let cell = tableView.cellForRow(at: IndexPath(row: num, section: 0)) {
            cell.imageView?.image = cell.imageView?.image == nil ? #imageLiteral(resourceName: "heartA") : nil
            cell.setNeedsLayout()//沒這行無法改動佈局(layout)
            //cell.imageView?.isHidden = true 試試看
        }
        
        tableView.scrollToRow(at: IndexPath(row: num, section: 0), at: .middle, animated: true)
        
        let alert = UIAlertController(title: arrShow[num] ? "\(num+1)變出來":"\(num+1)變不見" , message: nil, preferredStyle: .alert)
        present(alert, animated: true) {
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @objc func refresh(_ sender: UIBarButtonItem) {
        arrShow = Array(repeating: false, count: arrContents.count)
        tableView.reloadData()
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return arrContents.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "\(arrContents[indexPath.row])"
        cell.imageView?.image = arrShow[indexPath.row] ? #imageLiteral(resourceName: "heartA") : nil
        return cell
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
