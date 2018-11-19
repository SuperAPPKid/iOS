
//
//  TableViewController.swift
//  MVVM_Practice
//
//  Created by Hank_Zhong on 2018/11/15.
//  Copyright © 2018 Hank_Zhong. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController, TableViewCellDelegate {
    var cellViewModels: [CellViewModel] = []
    var animalModels: [AnimalModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.allowsSelection = false
        cellViewModels = animalModels.map({ (animal) -> CellViewModel in
            CellViewModel(title: animal.name, imageName: animal.imageName)
        })
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellViewModels.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell
        cell.bind(to: cellViewModels[indexPath.row])
        cell.delegate = self
        return cell
    }

    
    func fetchImageFail(_ tableViewCell: TableViewCell, error: Error) {
        
        let alertVC = UIAlertController(title: (error as NSError).domain, message: nil, preferredStyle: .alert)
        alertVC.addAction(.init(title: "OK", style: .default, handler: { (_) in
            tableViewCell.viewModel?.needFetchElement?.set(false, animated: true)
        }))
        present(alertVC, animated: true, completion: nil)
    }
    
    deinit {
        print("TableVC Dead")
    }
}
