//
//  TableViewController.swift
//  Coding Style
//
//  Created by Hank_Zhong on 2018/8/17.
//  Copyright © 2018年 Hank_Zhong. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    var cellViewModels: [CellViewModel] = []
    var detailViewModels: [DetailViewModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationbar()
        setupTable()
        APIService.shared.fetchItems(APIName: "Animals") { (items, error) -> (Void) in
            if let error = error {
                print(error.localizedDescription)
            }
            self.cellViewModels = items.map {
                CellViewModel(title: $0.title, imageName: $0.imageName, isGreen: false)
            }
            self.detailViewModels = items.map {
                DetailViewModel(title: $0.title, imageName: $0.imageName, detail: $0.detail)
            }
        }
    }
}

//MARK: Setup
extension TableViewController {
    private func setupNavigationbar() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    private func setupTable() {
        tableView.register(CustomTableViewCell.nib, forCellReuseIdentifier: CustomTableViewCell.identifier)
        tableView.rowHeight = 80
        tableView.estimatedRowHeight = 80
        tableView.separatorStyle = .none
    }
}

//MARK: TableViewDelegate
extension TableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let detailVC = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController else {
            return
        }
        detailVC.detailViewModel = detailViewModels[indexPath.row]
        detailVC.delegate = self
        detailVC.colorSwitchToLight = {
            [weak self] isOn in
            guard let `self` = self else { return }
            self.cellViewModels[indexPath.row].isGreen = isOn
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

//MARK: TableViewDataSource
extension TableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellViewModels.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.identifier, for: indexPath) as! CustomTableViewCell
        cell.cellViewModel = cellViewModels[indexPath.row]
        return cell
    }
}

extension TableViewController: DetailViewControllerDelegate {
    func detailImageViewDidOneSingleTap(_ detailVC: DetailViewController, action gesture: UITapGestureRecognizer) {
        navigationItem.title = "\(detailVC.detailViewModel.title) - one SingleTap"
    }
    
    func detailImageViewDidTwoSingleTap(_ detailVC: DetailViewController, action gesture: UITapGestureRecognizer) {
        navigationItem.title = "\(detailVC.detailViewModel.title) - two SingleTap"
    }
    
    func detailImageViewDidOneLongPress(_ detailVC: DetailViewController, action gesture: UILongPressGestureRecognizer) {
        navigationItem.title = "\(detailVC.detailViewModel.title) - LongPress"
    }
}
