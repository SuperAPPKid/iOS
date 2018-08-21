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
}

//MARK: Lifecycle
extension TableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationbar()
        setupTable()
        APIService.shared.fetchItems(APIName: "Animals") { (items, error) -> (Void) in
            if let error = error {
                print(error.localizedDescription)
            }
            self.cellViewModels = items.map {
                CellViewModel(title: $0.title, imageName: $0.imageName, isSelect: false)
            }
            self.detailViewModels = items.map {
                DetailViewModel(title: $0.title, imageName: $0.imageName, detail: $0.detail)
            }
        }
    }
}

//MARK: Setup
extension TableViewController {
    ///設定Navigationbar屬性
    private func setupNavigationbar() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        let navigationBar = navigationController?.navigationBar
        navigationBar?.barTintColor = Theme.NAVIGATIONBAR_COLOR.TINT //bar tint
        navigationBar?.tintColor = Theme.NAVIGATIONBAR_COLOR.TITLE //back button顏色
        navigationBar?.titleTextAttributes = [.foregroundColor: Theme.NAVIGATIONBAR_COLOR.TITLE] //小title顏色
        navigationBar?.largeTitleTextAttributes = [.foregroundColor: Theme.NAVIGATIONBAR_COLOR.TITLE] //大title顏色
    }
    
    ///設定tableView屬性
    private func setupTable() {
        tableView.register(CustomTableViewCell.nib, forCellReuseIdentifier: CustomTableViewCell.identifier)
        tableView.rowHeight = 80 //列高
        tableView.estimatedRowHeight = 80 //預估列高
        tableView.separatorStyle = .none //無分隔線
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
        detailVC.colorSwitchChanged = {
            [weak self] isOn in
            guard let `self` = self else { return }
            self.cellViewModels[indexPath.row].isSelect = isOn
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

//MARK: DetailViewControllerDelegate
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
