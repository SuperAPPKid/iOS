//
//  TableViewCell.swift
//  Spotify_Practice
//
//  Created by zhong on 2018/7/1.
//  Copyright © 2018年 zhong. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    var item:Item! {
        didSet {
            textLabel?.text = item.Title
        }
    }
    
    static var identifier:String  {
        return String(describing: self)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        if highlighted {
            textLabel?.textColor = .white
        } else {
            textLabel?.textColor = item.Selected ? .green : .red
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if item.Selected {
            textLabel?.textColor = .green
        } else {
            textLabel?.textColor = .red
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.backgroundColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
        selectionStyle = .none
        textLabel?.font = UIFont.boldSystemFont(ofSize: 22)
    }

}
