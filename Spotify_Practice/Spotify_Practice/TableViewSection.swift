//
//  TableViewSection.swift
//  Spotify_Practice
//
//  Created by zhong on 2018/7/3.
//  Copyright © 2018年 zhong. All rights reserved.
//

import UIKit

class TableViewSection: UITableViewHeaderFooterView {

    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var gradientView: UIView!
    
    static var identifier:String  {
        return String(describing: self)
    }
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        button.clipsToBounds = true
        button.layer.cornerRadius = 22.5
    }

    @IBAction func click(_ sender: UIButton) {
        print("click")
    }
    
}
