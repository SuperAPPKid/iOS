//
//  TableViewController.swift
//  DoSomeTransition
//
//  Created by Hank_Zhong on 2018/6/14.
//  Copyright © 2018年 Hank_Zhong. All rights reserved.
//

import UIKit

enum Section:Int {
    case Navigation
    case Tabbar
    case Modal
    case Default
    case Custom
}

class TableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let section = Section(rawValue: indexPath.section) ?? .Default
        switch section {
        case .Navigation:
            break
        case .Tabbar:
            break
        case .Modal:
            break
        case .Default:
            switch indexPath.row {
            case 1:
                let transitionVC = CATransitionVC()
                transitionVC.view.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
                navigationController?.pushViewController(transitionVC, animated: true)
                break
            default: break
            }
            break
        case .Custom:
            break
        }
    }
}
