//
//  MyViewController.swift
//  SearchController
//
//  Created by zhong on 2018/4/6.
//  Copyright © 2018年 zhong. All rights reserved.
//

import UIKit

class MyViewController: UIViewController {
    
    
    @IBOutlet weak var mySearchBarView: UIView!
    @IBOutlet weak var myTableView: UITableView!
    var searchController:CustomSearchController!
    var mySerachTable:MySearchResultTable!
    var myData = [String]()
    var myDataByLetters = [Character:[String]]()
    var filterData = [String]()
    var selections:[Bool] = []
    var isSearching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView.dataSource = self
        myTableView.delegate = self
        myTableView.register(MyHeader.nib, forHeaderFooterViewReuseIdentifier: MyHeader.identifier)
        loadListOfCountries()
        
        definesPresentationContext = true
        mySerachTable = storyboard?.instantiateViewController(withIdentifier: String(describing: MySearchResultTable.self)) as! MySearchResultTable
        searchController = CustomSearchController(searchResultsController: mySerachTable, searchBarFrame: CGRect(x: 0, y: 0, width: view.frame.width, height: 70), searchBarFont: UIFont(name: "Geeza Pro", size: 20)!, searchBarTextColor: UIColor.orange, searchBarTintColor: UIColor.white)
        searchController.searchBar.placeholder = "搜尋國家......"
        mySearchBarView.addSubview(searchController.searchBar)
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.dimsBackgroundDuringPresentation = true
    }
    
    
    
    func loadListOfCountries() {
        let pathToFile = Bundle.main.path(forResource: "countries", ofType: "txt")
        
        if let path = pathToFile {
            let countriesString = try! String.init(contentsOfFile: path, encoding: String.Encoding.utf8)
            myData = countriesString.components(separatedBy: "\n").filter({ (element) -> Bool in
                return element != ""
            })
            myDataByLetters = Dictionary(grouping: myData, by: { (element) -> Character in
                return element.first!
            })
            selections = Array(repeating: false, count: myDataByLetters.keys.count)
            myTableView.reloadData()
        }
    }
    
    
    
}
extension MyViewController:UITableViewDataSource,UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        if isSearching {
            return 1
        } else {
            return myDataByLetters.keys.count
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let myHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: MyHeader.identifier) as? MyHeader
        myHeader?.title.text = String(myDataByLetters.keys.sorted()[section])
        myHeader?.accessory.layer.setAffineTransform(CGAffineTransform(rotationAngle: (selections[section] ?  .pi / 2 : 0.0)))
        myHeader?.tapHandler = { [unowned self] in
            let change = !self.selections[section]
            self.selections[section] = change
            myHeader?.setCollapsed(collapsed: change)
            
            self.myTableView.reloadSections(IndexSet(integer: section), with: .fade)
            
            if self.selections[section] {
                self.myTableView.scrollToRow(at: IndexPath(row: 0, section: section), at: .top, animated: true)
            }
        }
        
        return myHeader
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if isSearching {
            return 0
        } else {
            return 65
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return filterData.count
        } else {
            if selections[section] {
                let key = myDataByLetters.keys.sorted()[section]
                return myDataByLetters[key]!.count
            } else {
                return 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if isSearching {
            cell.textLabel?.text = filterData[indexPath.row]
        } else {
            let key = myDataByLetters.keys.sorted()[indexPath.section]
            cell.textLabel?.text = myDataByLetters[key]![indexPath.row]
        }
        return cell
    }
}
extension MyViewController:UISearchResultsUpdating,UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchString = searchController.searchBar.text else {
            return
        }
        let filterArray = myData.filter { (country) -> Bool in
            return country.hasPrefix(searchString)
        }
        mySerachTable.myResultData = filterArray
        mySerachTable.tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            isSearching = false
            myTableView.reloadData()
        } else {
            isSearching = true
            guard let searchString = searchBar.text else {
                return
            }
            let filterArray = myData.filter { (country) -> Bool in
                return country.hasPrefix(searchString)
            }
            filterData = filterArray
            myTableView.reloadData()
            if myTableView.visibleCells.count != 0 {
                myTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
            }
        }
    }
    
}
