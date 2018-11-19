//
//  TableViewCell.swift
//  MVVM_Practice
//
//  Created by Hank_Zhong on 2018/11/15.
//  Copyright © 2018 Hank_Zhong. All rights reserved.
//

import UIKit

protocol TableViewCellDelegate: AnyObject {
    func fetchImageFail(_ tableViewCell: TableViewCell, error: Error)
}

class TableViewCell: UITableViewCell, Bindable {
    weak var viewModel: CellViewModel?  = nil
    
    @IBOutlet weak var resetButton: UIButton!
    
    @IBOutlet weak var thumbView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var progressBar: UIProgressView!
    
    @IBOutlet weak var downloadSwitch: UISwitch!
    
    weak var delegate: TableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func resetClick(_ sender: UIButton) {
        viewModel?.imageElement?.set(nil)
        viewModel?.needFetchElement?.set(false)
        viewModel?.progressElement?.set(0.0)
    }
    
    @IBAction func toogleDownload(_ sender: UISwitch) {
        viewModel?.needFetchElement?.set(sender.isOn)
    }
    
    func bind(to viewModel: CellViewModel) {
        self.viewModel = viewModel
        self.progressBar.progress = viewModel.progressElement?.value ?? 0.0
        
        viewModel.needFetchElement?.setUpdate{ [weak self] (viewModel, needFetch, animated) in
            guard let self = self,
                let viewModel = viewModel as? CellViewModel,
                let selfViewModel = self.viewModel,
                viewModel === selfViewModel else { return }
            
            self.downloadSwitch.setOn(needFetch ?? false, animated: animated)
            
            
            selfViewModel.fetchImage(size: self.thumbView.frame.size){ [weak self] (image, error) in
                if let error = error, let self = self {
                    self.delegate?.fetchImageFail(self, error: error)
                }
            }
        }
        
        viewModel.titleElement?.setUpdate{ [weak self] (viewModel, value, animated) in
            guard let self = self,
                let viewModel = viewModel as? CellViewModel,
                let selfViewModel = self.viewModel,
                viewModel === selfViewModel else { return }
            
            self.nameLabel.text = value
        }
        
        viewModel.progressElement?.setUpdate{ [weak self] (viewModel, value, animated) in
            guard let self = self,
                let viewModel = viewModel as? CellViewModel,
                let selfViewModel = self.viewModel,
                viewModel === selfViewModel else { return }
            
            self.resetButton.isEnabled = (value ?? 0.0) == 1.0
            self.progressBar.setProgress(value ?? 0.0, animated: (value ?? 0.0) != 0.0)
        }
        
        viewModel.imageElement?.setUpdate{ [weak self] (viewModel, value, animated) in
            guard let self = self,
                let viewModel = viewModel as? CellViewModel,
                let selfViewModel = self.viewModel,
                viewModel === selfViewModel else { return }
            
            self.thumbView.image = value
        }
    }
    
    deinit {
        print("Cell Dead")
    }
    
}
