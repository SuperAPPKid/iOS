//
//  ViewController.swift
//  AutoSizeCollectionCell
//
//  Created by zhong on 2018/6/3.
//  Copyright © 2018年 zhong. All rights reserved.
//

import UIKit
struct Model {
    var imgName:String
    var isBig:Bool
}
enum LayoutMode {
    case Default,Square,WaterFall,Line
}
class ViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    let DEVICE_WIDTH = UIScreen.main.bounds.width
    var column:CGFloat = 3
    var layout:LayoutMode = .Default
    var cellModel:[Model] = [Model(imgName: "1", isBig: true),Model(imgName: "2", isBig: false),Model(imgName: "3", isBig: false),Model(imgName: "4", isBig: false),Model(imgName: "5", isBig: false),Model(imgName: "6", isBig: false),Model(imgName: "7", isBig: false),Model(imgName: "8", isBig: false),Model(imgName: "9", isBig: false),Model(imgName: "10", isBig: false),Model(imgName: "1", isBig: false),Model(imgName: "2", isBig: false),Model(imgName: "3", isBig: false),Model(imgName: "4", isBig: false),Model(imgName: "5", isBig: false),Model(imgName: "6", isBig: false),Model(imgName: "7", isBig: false),Model(imgName: "8", isBig: false),Model(imgName: "9", isBig: false),Model(imgName: "10", isBig: false),Model(imgName: "1", isBig: false),Model(imgName: "2", isBig: false),Model(imgName: "3", isBig: false),Model(imgName: "4", isBig: false),Model(imgName: "5", isBig: false),Model(imgName: "6", isBig: false),Model(imgName: "7", isBig: false),Model(imgName: "8", isBig: false),Model(imgName: "9", isBig: false),Model(imgName: "10", isBig: false),Model(imgName: "1", isBig: false),Model(imgName: "2", isBig: false),Model(imgName: "3", isBig: false),Model(imgName: "4", isBig: false),Model(imgName: "5", isBig: false),Model(imgName: "6", isBig: false),Model(imgName: "7", isBig: false),Model(imgName: "8", isBig: false),Model(imgName: "9", isBig: false),Model(imgName: "10", isBig: false)]
    let cellHeights:[CGFloat] = [150,280,350,150,180,
                                 350,180,250,150,280,
                                 250,180,150,150,180,
                                 150,280,350,250,280,
                                 250,180,250,150,180,
                                 350,380,150,250,180,
                                 450,180,350,150,380,
                                 150,280,150,250,180]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.shadowImage = UIImage()
        collectionView.dataSource = self
        collectionView.delegate = self
        layout = LayoutMode.Square
        let square = MyCollectionViewSquareLayout(columnCount: column)
        square.delegate = self
        collectionView.setCollectionViewLayout(square, animated: true)
    }

    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 1:
            layout = LayoutMode.Square
            let square = MyCollectionViewSquareLayout(columnCount: column)
            square.delegate = self
            collectionView.setCollectionViewLayout(square, animated: false)
            collectionView.reloadData()
            break
        case 2:
            layout = LayoutMode.WaterFall
            let waterFall = MyCollectionViewWaterFallLayout()
            waterFall.columnCount = 3
            waterFall.delegate = self
            collectionView.setCollectionViewLayout(waterFall, animated: false)
            collectionView.contentOffset = CGPoint(x: 0, y: 0)
            collectionView.reloadData()
            break
        case 3:
            layout = LayoutMode.Line
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: [.transitionCurlDown], animations: {
                self.collectionView.setCollectionViewLayout(MyCollectionViewLineLayout(), animated: false)
            }, completion: nil)
            collectionView.reloadData()
            break
        default:
            layout = LayoutMode.Default
            self.setDefaultLayout()
        }
    }
    
    func setDefaultLayout() -> Void {
        let flow = UICollectionViewFlowLayout()
        flow.itemSize = CGSize(width: (DEVICE_WIDTH - 20) / 3, height: (DEVICE_WIDTH - 20) / 3)
        flow.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        flow.minimumInteritemSpacing = 5
        flow.minimumLineSpacing = 5
        collectionView.setCollectionViewLayout(flow, animated: true)
    }
}
extension ViewController:UICollectionViewDataSource,UICollectionViewDelegate{
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return cellModel.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MyCell
        cell.thumbView.image = UIImage(named: cellModel[indexPath.row].imgName)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if layout == .Square && !cellModel[indexPath.row].isBig {
            for i in 0..<cellModel.count{
                cellModel[i].isBig = false
            }
            cellModel[indexPath.row].isBig = true
            collectionView.reloadData()
        } else {
            performSegue(withIdentifier: "toDetail", sender: nil)
        }
    }
}
extension ViewController:MyCollectionViewSquareLayoutDelegate{
    
    func checkVertical(by indexPath: IndexPath) -> Bool {
        return cellModel[indexPath.row].isBig
    }
    
    func sizeForCell(at indexPath: IndexPath, with padding: CGFloat, and insets: CGFloat) -> CGSize {
        var cellW = (collectionView.frame.width - insets * 2 - padding * (column - 1)) / column
        
        if cellModel[indexPath.row].isBig {
            cellW = collectionView.frame.width - insets * 2 - padding - cellW
        }
        return CGSize(width: cellW, height: cellW)
    }
    
}
extension ViewController:MyCollectionViewWaterFallLayoutDelegate{
    func heightForCell(at indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath.row]
    }
}
