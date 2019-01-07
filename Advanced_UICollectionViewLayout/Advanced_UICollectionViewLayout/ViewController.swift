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
    
    typealias LazyTuple = (name: String, value: LazyLayout)
    var myLayouts: [LazyTuple] = []
    var pickerView: UIPickerView?
    
    var cellViewModel: [UIColor] = {
        var colorArr = [UIColor]()
        for i in 0 ..< 8 {
            colorArr.append(UIColor.random(alpha: 1))
        }
        return colorArr
    }()
    
    var hashTable: [Int:String] = [
        0:"零", 1:"一", 2:"二", 3:"三", 4:"四",
        5:"五", 6:"六", 7:"七", 8:"八", 9:"九"
    ]
    
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
        
        let layout3 = TestFlowLayout.lazy {
            let layout = TestFlowLayout(name: "33333")
            let itemLength = (self.collectionView.bounds.width - 40) / 3
            layout.itemSize = CGSize(width: itemLength, height: itemLength)
            layout.minimumLineSpacing = 10
            layout.minimumInteritemSpacing = 0
            layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            return layout
        }
        
        let layout4 = TestFlowLayout.lazy {
            let layout = TestFlowLayout(name: "44444")
            let itemLength = (self.collectionView.bounds.width - 50) / 4
            layout.itemSize = CGSize(width: itemLength, height: itemLength)
            layout.minimumLineSpacing = 10
            layout.minimumInteritemSpacing = 0
            layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            return layout
        }
        
        let layoutRotation = RotationFlowLayout.defaultLazy() as LazyLayout
        
        //Bad transition animation
        //        let layoutOnelineH = OnelineFlowLayout.lazy {
        //            let layout = OnelineFlowLayout()
        //            layout.minimumLineSpacing = 10
        //            layout.itemSize = CGSize(width: 50, height: 50)
        //            layout.minimumZoomScope = 200
        //            layout.sectionInset.left = 50
        //            layout.sectionInset.right = 50
        //            layout.scrollDirection = .horizontal
        //            return layout
        //        }
        //
        //        let layoutOnelineV = OnelineFlowLayout.lazy {
        //            let layout = OnelineFlowLayout()
        //            layout.minimumLineSpacing = 75
        //            layout.itemSize = CGSize(width: 125, height: 125)
        //            layout.maxZoomScale = 1.8
        //            layout.sectionInset.top = 150
        //            layout.sectionInset.bottom = 150
        //            layout.scrollDirection = .vertical
        //            return layout
        //        }
        
        let newOneLayoutV = NewOnelineLayout.lazy {
            let layout = NewOnelineLayout(size: CGSize(width: 187, height: 87), space: 15)
            return layout
        }
        
        let newOneLayoutH = NewOnelineLayout.lazy {
            let layout = NewOnelineLayout(size: CGSize(width: 185, height: 350), space: 100)
            layout.preferDirection = .horizon
            layout.maxZoomScale = 1.65
            return layout
        }
        
        let mosaicLayout = MosaicLayout.lazy {
            let layout = MosaicLayout()
            layout.length = 180
            layout.space = 8
            layout.preferStyles = [.oneThirdTwoThirds, .twoThirdsOneThird, .fiftyFifty, .twoThirdsOneThird]
            return layout
        }
        
        let circleLayout = CircleLayout.lazy {
            let layout = CircleLayout()
            layout.size = CGSize(width: 40, height: 40)
            layout.radius = 170
            return layout
        }
        
        let waterfallLayout3 = WaterFallLayout.lazy {
            let layout = WaterFallLayout()
            layout.columnCount = 3
            layout.delegate = self
            return layout
        }
        
        let waterfallLayout5 = WaterFallLayout.lazy {
            let layout = WaterFallLayout()
            layout.columnCount = 5
            layout.edgeInsets = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
            layout.columnSpace = 3
            layout.rowSpace = 3
            layout.delegate = self
            return layout
        }
        
        let stackLayout = StackLayout.lazy {
            let layout = StackLayout()
            layout.overlapSpace = 35
            return layout
        }
        
        let ringLayout = RingLayout.lazy {
            let layout = RingLayout()
            return layout
        }
        
        myLayouts += [LazyTuple("RingLayout", ringLayout),
                      LazyTuple("Layout3", layout3),
                      LazyTuple("Layout4", layout4),
                      LazyTuple("RotationLayout", layoutRotation),
                      LazyTuple("NewLayout Vertical", newOneLayoutV),
                      LazyTuple("NewLayout Horizontal", newOneLayoutH),
                      LazyTuple("stackLayout", stackLayout),
                      LazyTuple("MosaicLayout", mosaicLayout),
                      LazyTuple("waterfallLayout3", waterfallLayout3),
                      LazyTuple("waterfallLayout5", waterfallLayout5),
                      LazyTuple("CircleLayout", circleLayout)]
        
        collectionView.dataSource = self
        collectionView.register(MyCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.setCollectionViewLayout(myLayouts.first!.value.layout, animated: true)
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
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        if let view = view as? UILabel {
            return view
        } else {
            let titleLabel = UILabel()
            titleLabel.text = myLayouts[row].name
            titleLabel.textAlignment = .center
            titleLabel.font = UIFont(name: "Noteworthy-Bold", size: 20)!
            titleLabel.textColor = .red
            return titleLabel
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let newLayout = myLayouts[row].value.layout
        //        print(String(describing: type(of: newLayout)))
        UIView.animate(withDuration: 0.8) {
            self.collectionView.setCollectionViewLayout(newLayout, animated: true)
        }
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellViewModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! MyCell
        cell.backgroundColor = cellViewModel[indexPath.row]
        let text = String(indexPath.row).compactMap{Int(String($0))}.compactMap{hashTable[$0]}.joined()
        cell.text = text
        return cell
    }
}

extension ViewController: WaterFallLayoutDelegate {
    func waterFall(layout: WaterFallLayout, heightFor indexPath: IndexPath) -> CGFloat {
        return [CGFloat(80), CGFloat(100), CGFloat(125), CGFloat(200), CGFloat(240)].randomElement() ?? CGFloat(87)
    }
}
