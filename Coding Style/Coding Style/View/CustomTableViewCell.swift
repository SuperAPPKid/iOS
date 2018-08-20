//
//  CustomTableViewCell.swift
//  Coding Style
//
//  Created by Hank_Zhong on 2018/8/17.
//  Copyright © 2018年 Hank_Zhong. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell, XibCell {
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    let greenLayer: CAShapeLayer = CAShapeLayer()
    
    var cellViewModel: CellViewModel! {
        didSet {
            thumbImageView.image = UIImage(named: cellViewModel.imageName)?.scaleTo(size: thumbImageView.frame.size, needTrim: true, renderMode: .alwaysOriginal)
            titleLabel.text = cellViewModel.title
            greenLayer.isHidden = !cellViewModel.isGreen
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        thumbImageView.layer.cornerRadius = 30
        greenLayer.frame = CGRect(x: 0, y: 0, width: 10, height: 80)
        greenLayer.backgroundColor = #colorLiteral(red: 0.6089995114, green: 1, blue: 0.3493120194, alpha: 1)
        layer.addSublayer(greenLayer)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        accessoryType = .disclosureIndicator
        selectionStyle = .none
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        backgroundColor = isHighlighted ? #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1):#colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.9568627451, alpha: 1)
    }
    
}
