//
//  MVVMViewController.swift
//  MVP+MVVM
//
//  Created by Hank_Zhong on 2018/6/20.
//  Copyright © 2018年 Hank_Zhong. All rights reserved.
//

import UIKit
protocol MVVM_HomeViewProtocol {
    func getTextfieldText(text:String?)
}
class MVVM_HomeViewController: UIViewController {
    var delegate:MVVM_HomeViewProtocol?
    let textField:UITextField = UITextField(frame: CGRect(x: 0, y: 0, width: 200, height: 80))
    let button:UIButton = UIButton(type: UIButtonType(rawValue: 1)!)
    lazy var viewModel = MVVM_HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSubView()
        configureViewModel()
    }
    
    func configureSubView() {
        textField.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(textField)
        self.view.addSubview(button)
        button.setTitle("click!!", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        button.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        button.widthAnchor.constraint(equalToConstant: 100).isActive = true
        button.heightAnchor.constraint(equalToConstant: 100).isActive = true
        textField.borderStyle = .roundedRect
        textField.font = UIFont(name:"Apple Color Emoji", size:20)
        textField.minimumFontSize = 0
        textField.adjustsFontSizeToFitWidth = true
        textField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        textField.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -50).isActive = true
        textField.widthAnchor.constraint(equalToConstant: 300).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 100).isActive = true
        button.addTarget(self, action: #selector(buttonDidTouchUpInside), for: .touchUpInside)
    }

    func configureViewModel() {
        delegate = viewModel
        viewModel.showResponse = { [weak self] response in
            let alert = UIAlertController(title: response, message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self?.present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func buttonDidTouchUpInside() {
        delegate?.getTextfieldText(text: textField.text)
    }
}
