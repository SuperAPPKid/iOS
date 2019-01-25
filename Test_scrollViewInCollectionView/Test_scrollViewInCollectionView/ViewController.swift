//
//  ViewController.swift
//  Test_scrollViewInCollectionView
//
//  Created by Hank_Zhong on 2019/1/24.
//  Copyright © 2019 Hank_Zhong. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        return cell
    }
    
    var collectionView: CollectionView!
    var flowLayout: UICollectionViewFlowLayout {
        return collectionView.collectionViewLayout as! UICollectionViewFlowLayout
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView = CollectionView(frame: view.bounds, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.dataSource = self
        collectionView.backgroundColor = .green
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.isPagingEnabled = true
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = collectionView.bounds.size
        view.addSubview(collectionView)
    }

}

