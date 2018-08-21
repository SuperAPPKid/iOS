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
    let selectedLayer: CAShapeLayer = CAShapeLayer()
    
    var cellViewModel: CellViewModel! {
        didSet {
            thumbImageView.image = UIImage(named: cellViewModel.imageName)?.scaleTo(size: thumbImageView.frame.size, needTrim: true, renderMode: .alwaysOriginal)
            titleLabel.text = cellViewModel.title
            selectedLayer.isHidden = !cellViewModel.isSelect //設置select
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        accessoryType = .disclosureIndicator // >符號
        selectionStyle = .none // 取消預設選取色
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        thumbImageView.layer.cornerRadius = 30 //圓形thumb
        
        //select 狀態 layer
        selectedLayer.frame = CGRect(x: 0, y: 0, width: 10, height: 80)
        selectedLayer.backgroundColor = Theme.SELECTED_COLOR.cgColor
        layer.addSublayer(selectedLayer)
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        backgroundColor = isHighlighted ? Theme.HIGHTLIGHT_COLOR.YES: Theme.HIGHTLIGHT_COLOR.NO //設置highlight
    }
    
}
