//
//  ViewController.swift
//  Advanced_UICollectionViewLayout
//
//  Created by Hank_Zhong on 2018/12/20.
//  Copyright © 2018 Hank_Zhong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var myLayouts: [LazyLayout] = [UICollectionViewFlowLayout.defaultLazy,
                                   UICollectionViewFlowLayout.customLazy{ UICollectionViewFlowLayout() },
                                   MyLayout1.defaultLazy,
                                   MyLayout1.customLazy{ MyLayout1() },
                                   MyLayout2.defaultLazy,
                                   MyLayout2.customLazy{ MyLayout2() }]
    var pickerView: UIPickerView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        editButtonItem.title = "Change"
        navigationItem.rightBarButtonItem = editButtonItem
        
        let picker = UIPickerView()
        view.addSubview(picker)
        picker.backgroundColor = #colorLiteral(red: 1, green: 0.7257020473, blue: 0.9242931604, alpha: 1)
        picker.isHidden = true
        picker.dataSource = self
        picker.delegate = self
        
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        picker.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        picker.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        picker.heightAnchor.constraint(equalToConstant: 300).isActive = true
        pickerView = picker
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        pickerView?.isHidden = !editing
    }

}

extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return myLayouts.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(describing: type(of: myLayouts[row].wake()))
    }
}

struct LazyLayout {
    var layoutClz: () -> (UICollectionViewLayout)
    
    init(_ clz: @escaping ()->(UICollectionViewLayout)) {
        self.layoutClz = clz
    }
    
    func wake() -> UICollectionViewLayout {
        return layoutClz()
    }
}

protocol HasLazyLayout where Self: UICollectionViewLayout {
    static var defaultLazy: LazyLayout { get }
}

extension HasLazyLayout where Self: UICollectionViewLayout {
    static func customLazy(_ clz: @escaping () -> (Self)) -> LazyLayout {
        return LazyLayout(clz)
    }
}

extension HasLazyLayout where Self: UICollectionViewFlowLayout {
    static var defaultLazy: LazyLayout {
        return LazyLayout{ UICollectionViewFlowLayout() }
    }
}

extension UICollectionViewFlowLayout: HasLazyLayout{}

class MyLayout1: UICollectionViewLayout, HasLazyLayout {
    static var defaultLazy: LazyLayout {
        return LazyLayout{ MyLayout1() }
    }
}

class MyLayout2: UICollectionViewFlowLayout {
    static var defaultLazy: LazyLayout {
        return LazyLayout{ MyLayout2() }

    }
}
