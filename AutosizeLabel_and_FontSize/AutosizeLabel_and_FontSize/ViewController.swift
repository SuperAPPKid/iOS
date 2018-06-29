//
//  ViewController.swift
//  AutosizeLabel_and_FontSize
//
//  Created by Hank_Zhong on 2018/6/29.
//  Copyright © 2018年 Hank_Zhong. All rights reserved.
//

import UIKit

enum PickerTag:Int {
    case fontSize,labelWidth,labelHeight
}

class ViewController: UIViewController {

    @IBOutlet weak var pickerStackView: UIStackView!
    @IBOutlet weak var textfield: UITextField!
    @IBOutlet weak var label: UILabel!
    var pickerViews:[UIPickerView] = [UIPickerView]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for (index,pickView) in pickerStackView.arrangedSubviews.enumerated() {
            guard let pickView = pickView as? UIPickerView else { return }
            pickView.delegate = self
            pickView.dataSource = self
            pickView.tag = index
            pickerViews.append(pickView)
        }
    }

}
extension ViewController:UIPickerViewDelegate,UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 5
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 30
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 100
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "GO"
    }

    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let string = NSAttributedString(string: "OMG", attributes: [NSAttributedStringKey.foregroundColor:UIColor.white])
        return string
    }
    
//    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
//        let view = UILabel()
//        view.text = "HAHA"
//        view.textAlignment = .center
//        view.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
//        return view
//    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("...")
    }
}

