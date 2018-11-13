//
//  ViewController.swift
//  MVVM_Practice
//
//  Created by Hank_Zhong on 2018/11/13.
//  Copyright © 2018 Hank_Zhong. All rights reserved.
//

import UIKit

class ViewController: UIViewController, ObserveElementDelegate {
    var helloLabel: UILabel!
    var worldLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        helloLabel = UILabel(frame: .init(x: 50, y: 80, width: 100, height: 100))
        worldLabel = UILabel(frame: .init(x: 50, y: 200, width: 100, height: 100))
        [helloLabel, worldLabel].forEach{ $0?.textAlignment = .center }
        
        view.addSubview(helloLabel)
        view.addSubview(worldLabel)
        
        let helloViewModel = LabelViewModel(seconds: 3, color: #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1))
        helloViewModel.colorElement.delegate = self
        helloLabel.bind(to: helloViewModel)
        helloViewModel.textElement.value = "HELLO"
        helloViewModel.colorElement.value = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        
        
        let worldViewModel = LabelViewModel(seconds: 5, color: #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1))
        worldViewModel.textElement.delegate = self
        worldLabel.bind(to: worldViewModel)
        worldViewModel.textElement.value = "WORLD"
        worldViewModel.colorElement.value = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
    }
    
    func shouldUpdateView(_ ObserveElement: Any) -> Bool {
        if let element = ObserveElement as? ObserveElement<String> {
            print("WILL:\(element.value)")
            if element.value == "GOGOGO" {
                return false
            }
        }
        return true
    }
    
    func didUpdateView(_ ObserveElement: Any) {
        if let element = ObserveElement as? ObserveElement<String> {
            print("DID:\(element.value)")
        }
    }

}

extension UILabel: Bindable {
    func bind(to viewModel: LabelViewModel) {
        viewModel.textElement.update({ (value) in
            self.text = value
        })
        viewModel.colorElement.update { (value) in
            self.backgroundColor = value
        }
    }
}

class LabelViewModel {
    var textElement = ObserveElement("")
    var colorElement = ObserveElement(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
    init(seconds: Int, color: UIColor) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(seconds)) {
            self.textElement.value = "GOGOGO"
            self.colorElement.value = color
        }
    }
}

@objc protocol ObserveElementDelegate: AnyObject {
    @objc optional func shouldUpdateView(_ ObserveElement: Any) -> Bool
    @objc optional func didUpdateView(_ ObserveElement: Any)
}

class ObserveElement<T> {
    var value: T {
        didSet {
            if let delegate = delegate {
                if (delegate.shouldUpdateView?(self) ?? true) {
                    callBack?(value)
                } else {
                    value = oldValue
                }
                delegate.didUpdateView?(self)
            } else {
                callBack?(value)
            }
        }
    }
    
    private var callBack: ((T) -> ())?
    
    weak var delegate: ObserveElementDelegate?
    
    weak var view: UIView?
    
    init(_ element: T) {
        self.value = element
    }
    
    func update(_ callBack: @escaping (_ value:T)->()) {
        callBack(value)
        
        self.callBack = callBack
    }
}

protocol Bindable {
    associatedtype T
    func bind(to viewModel: T)
}

