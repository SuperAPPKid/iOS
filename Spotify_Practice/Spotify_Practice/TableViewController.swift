//
//  TableViewController.swift
//  Spotify_Practice
//
//  Created by zhong on 2018/7/1.
//  Copyright © 2018年 zhong. All rights reserved.
//

typealias Item = (Title:String,Selected:Bool)

import UIKit

class TableViewController: UITableViewController {
    
    var data:[Item] = [Item(Title:"Hello World",Selected:false),
                       Item(Title:"Good Morning",Selected:false),
                       Item(Title:"I'm Hungry",Selected:false),
                       Item(Title:"SuperMan",Selected:false),
                       Item(Title:"GOGOGOGO",Selected:false),
                       Item(Title:"I'm Sad",Selected:false),
                       Item(Title:"World Cup",Selected:false),
                       Item(Title:"You are Champion",Selected:false),
                       Item(Title:"Boys and Girls",Selected:false),
                       Item(Title:"Mr.Jin",Selected:false),
                       Item(Title:"Swift Yes",Selected:false),
                       Item(Title:"Objc No",Selected:false),
                       Item(Title:"HA HA HA",Selected:false),
                       Item(Title:"HO HO HO",Selected:false),
                       Item(Title:"Cat cute",Selected:false),
                       Item(Title:"Meow Meow",Selected:false),
                       Item(Title:"!!!!!!!!",Selected:false)]
    var imageView:UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Spotify"
        imageView = UIImageView(image: #imageLiteral(resourceName: "Goats-maximili"))
        imageView.contentMode = .scaleAspectFill
        imageView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 375)
        view.addSubview(imageView)
        
        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.identifier)
        tableView.register(TableViewSection.nib, forHeaderFooterViewReuseIdentifier: TableViewSection.identifier)
        tableView.backgroundColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
        tableView.separatorStyle = .none
        tableView.sectionHeaderHeight = 45
        tableView.rowHeight = 60
        tableView.showsVerticalScrollIndicator = false
        
        let header = UINib(nibName: "TableHeader", bundle: nil).instantiate(withOwner: nil, options: nil).first as! TableHeader
        let headerContainer = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 350))
        headerContainer.addSubview(header)
        header.frame = headerContainer.bounds
        tableView.tableHeaderView?.translatesAutoresizingMaskIntoConstraints = false
        tableView.tableHeaderView = headerContainer
        tableView.tableHeaderView?.backgroundColor = .clear
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier, for: indexPath) as! TableViewCell
        cell.item = self.data[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        for i in 0..<data.count {
            data[i].Selected = false
        }
        data[indexPath.row].Selected = true
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionView = tableView.dequeueReusableHeaderFooterView(withIdentifier: TableViewSection.identifier) as! TableViewSection
        sectionView.gradientView.alpha = tableView.contentOffset.y > 350 ? 1:0
        return sectionView
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let tableView = scrollView as? UITableView,
              let sectionView = tableView.headerView(forSection: 0) as? TableViewSection else {
            return
        }
        let y = tableView.contentOffset.y
        print(y)
        if y > 350 {
            if sectionView.gradientView.alpha != 1 {
                sectionView.gradientView.alpha = 1
                sectionView.gradientView.transform = CGAffineTransform(translationX: 0, y: -20)
                UIView.animate(withDuration: 0.15) {
                    sectionView.gradientView.transform = CGAffineTransform(translationX: 0, y: 0)
                    sectionView.button.transform = CGAffineTransform(a: 1.2, b: 0, c: 0, d: 1.2, tx: 0, ty: sectionView.button.frame.height * 0.2)
                }
            }
        } else {
            UIView.animate(withDuration: 0.15) {
                sectionView.button.transform = .identity
            }
            sectionView.gradientView.alpha = 0
        }
        if y < 0 {
            imageView.frame.size = .init(width: view.frame.width * (1-y/375), height: 375 - y)
            imageView.frame.origin.y = y
            imageView.center.x = view.center.x
        }
    }
}
