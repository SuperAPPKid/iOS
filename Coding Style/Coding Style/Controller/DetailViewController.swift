//
//  DetailViewController.swift
//  Coding Style
//
//  Created by Hank_Zhong on 2018/8/17.
//  Copyright © 2018年 Hank_Zhong. All rights reserved.
//

import UIKit

protocol DetailViewControllerDelegate: AnyObject {
    func detailImageViewDidOneSingleTap(_ detailVC: DetailViewController, action gesture:UITapGestureRecognizer)
    func detailImageViewDidTwoSingleTap(_ detailVC: DetailViewController, action gesture:UITapGestureRecognizer)
    func detailImageViewDidOneLongPress(_ detailVC: DetailViewController, action gesture:UILongPressGestureRecognizer)
}

class DetailViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var colorSwitch: UISwitch!
    
    var detailViewModel: DetailViewModel!
    var colorSwitchChanged: ((Bool) -> (Void))? //觸發switch
    weak var delegate: DetailViewControllerDelegate?
}

//MARK: Lifecycle
extension DetailViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = detailViewModel.title
        
        imageView.image = UIImage(named: detailViewModel.imageName)?.scaleTo(size: imageView.frame.size, needTrim: true, renderMode: .alwaysOriginal)
        
        textView.text = detailViewModel.detail
        
        colorSwitch.isOn = detailViewModel.isSelect //右上按鈕選取狀態
        colorSwitch.addTarget(self, action: #selector(colorSwitchChanged(_:)), for: .valueChanged)
        
        setupGestures()
    }
}

//MARK: Setup
extension DetailViewController {
    private func setupGestures() {
        let oneSingleTap = UITapGestureRecognizer(target: self, action: #selector(imageViewOneSingleTap(_:))) //單指單擊手勢
        oneSingleTap.numberOfTapsRequired = 1 //單擊
        oneSingleTap.numberOfTouchesRequired = 1 //1指
        
        let twoSingleTap = UITapGestureRecognizer(target: self, action: #selector(imageViewTwoSingleTap(_:))) //單指雙擊手勢
        twoSingleTap.numberOfTapsRequired = 2 //雙擊
        twoSingleTap.numberOfTouchesRequired = 1 //1指
        oneSingleTap.require(toFail: twoSingleTap) //確定雙擊手勢失敗才觸發單擊手勢
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(imageViewOneLongPress(_:))) //長按手勢
        
        imageView.addGestureRecognizer(oneSingleTap)
        imageView.addGestureRecognizer(twoSingleTap)
        imageView.addGestureRecognizer(longPress)
    }
    
}

//MARK: Interaction Handler
extension DetailViewController {
    @objc func colorSwitchChanged(_ sender: UISwitch) {
        detailViewModel.isSelect = sender.isOn
        colorSwitchChanged?(sender.isOn)
    }
    
    @objc func imageViewOneSingleTap(_ sender: UITapGestureRecognizer) {
        navigationItem.title = "one SingleTap"
        delegate?.detailImageViewDidOneSingleTap(self, action: sender)
    }
    
    @objc func imageViewTwoSingleTap(_ sender: UITapGestureRecognizer) {
        navigationItem.title = "two SingleTap"
        delegate?.detailImageViewDidTwoSingleTap(self, action: sender)
    }
    
    @objc func imageViewOneLongPress(_ sender: UILongPressGestureRecognizer) {
        switch sender.state {
        case .began:
            navigationItem.title = "LongPress Begin"
            break
        case .changed:
            navigationItem.title = "LongPress Change"
            break
        case .ended:
            navigationItem.title = "LongPress End"
            break
        default:
            return
        }
        delegate?.detailImageViewDidOneLongPress(self, action: sender)
    }
}

