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
    
    typealias LazyTuple = (name: String,lazy: LazyLayout)
    var myLayouts: [LazyTuple] = []
    var pickerView: UIPickerView?
    
    var cellViewModel: [UIColor] = [#colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1), #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1), #colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0, alpha: 1), #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1), #colorLiteral(red: 0, green: 0.9914394021, blue: 1, alpha: 1), #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1), #colorLiteral(red: 0.5791940689, green: 0.1280144453, blue: 0.5726861358, alpha: 1), #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1), #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1), #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1), #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1), #colorLiteral(red: 0.4508578777, green: 0.9882974029, blue: 0.8376303315, alpha: 1), #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1), #colorLiteral(red: 0.5808190107, green: 0.0884276256, blue: 0.3186392188, alpha: 1), #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        editButtonItem.title = "Change"
        navigationItem.rightBarButtonItem = editButtonItem
        
        let picker = UIPickerView()
        view.addSubview(picker)
        picker.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.7005029966)
        picker.isHidden = true
        picker.dataSource = self
        picker.delegate = self
        
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        picker.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        picker.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        picker.heightAnchor.constraint(equalToConstant: 200).isActive = true
        pickerView = picker
        
        let layout3 = TestDeinitLayout.customLazy{
            let layout = TestDeinitLayout()
            let itemLength = (self.view.bounds.width - 40) / 3
            layout.itemSize = CGSize(width: itemLength, height: itemLength)
            layout.minimumLineSpacing = 10
            layout.minimumInteritemSpacing = 0
            layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            return layout
        }
        
        let layout4 = TestDeinitLayout.customLazy {
            let layout = TestDeinitLayout()
            let itemLength = (self.view.bounds.width - 50) / 4
            layout.itemSize = CGSize(width: itemLength, height: itemLength)
            layout.minimumLineSpacing = 10
            layout.minimumInteritemSpacing = 0
            layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            return layout
        }
        
        let layout5 = TestDeinitLayout.customLazy {
            let layout = TestDeinitLayout()
            let itemLength = (self.view.bounds.width - 60) / 5
            layout.itemSize = CGSize(width: itemLength, height: itemLength)
            layout.minimumLineSpacing = 10
            layout.minimumInteritemSpacing = 0
            layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            return layout
        }
        
        let layout242 = My242FlowLayout.defaultLazy
        
        myLayouts += [("Flow-3", layout3), ("Flow-4", layout4), ("Flow-5", layout5), ("MyFlow-242", layout242)]
        
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.setCollectionViewLayout(layout3.wake(), animated: true)
        
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
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let name = NSAttributedString(string: myLayouts[row].name, attributes: [.font: UIFont(name: "Papyrus", size: 20) ?? UIFont.boldSystemFont(ofSize: 20),
                                                                                .foregroundColor: UIColor.red])
        return name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let newLayout = myLayouts[row].lazy.wake()
        print(String(describing: type(of: newLayout)))
        collectionView.setCollectionViewLayout(newLayout, animated: true)
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellViewModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        cell.backgroundColor = cellViewModel[indexPath.row]
        return cell
    }
}

class TestDeinitLayout: UICollectionViewFlowLayout {
    override init() {
        super.init()
        print("?????Born?????")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("!!!!!Dead!!!!!")
    }
}