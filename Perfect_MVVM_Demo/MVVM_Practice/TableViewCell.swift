//
//  TableViewCell.swift
//  MVVM_Practice
//
//  Created by Hank_Zhong on 2018/11/15.
//  Copyright © 2018 Hank_Zhong. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell, Bindable {
    weak var viewModel: CellViewModel?  = nil
    
    @IBOutlet weak var thumbView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var progressBar: UIProgressView!
    
    @IBOutlet weak var toogleSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

    func bind(to viewModel: CellViewModel) {
        viewModel.isCheckedElement.setUpdate { (value) in
            self.toogleSwitch.isOn = value ?? false
        }
        viewModel.titleElement.setUpdate { (value) in
            self.nameLabel.text = value
        }
        viewModel.progressElement.setUpdate { (value) in
            self.progressBar.progress = value ?? 0.0
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
}

class CellViewModel {
    var titleElement: ObserveElement<String>
    var isCheckedElement: ObserveElement<Bool>
    var progressElement: ObserveElement<Float>
    var imageElement: ObserveElement<UIImage>
    init(title: String, isChecked: Bool, progress: Float, imageName: String) {
        self.titleElement = ObserveElement(title)
        self.isCheckedElement = ObserveElement(isChecked)
        self.progressElement = ObserveElement(progress)
        self.imageElement = ObserveElement<UIImage>()
    }
}
