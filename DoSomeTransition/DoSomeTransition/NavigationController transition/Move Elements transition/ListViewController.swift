//
//  ListViewController.swift
//  DoSomeTransition
//
//  Created by Hank_Zhong on 2018/9/21.
//  Copyright © 2018年 Hank_Zhong. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"
typealias Animal = (name: String, thumb: UIImage?)

fileprivate class ImageCell: UICollectionViewCell {
    private(set) var imageView: UIImageView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView = UIImageView(frame: .zero)
        imageView.frame = contentView.bounds
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        contentView.addSubview(imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ListViewController: UICollectionViewController {
    var animals: [Animal] = []
    private var selectedCell: UICollectionViewCell?

    override func viewDidLoad() {
        super.viewDidLoad()
        let animals = [(name: "Giant Panda", thumb:  #imageLiteral(resourceName: "Giant Panda").scaleTo(size: CGSize(width: 100, height: 100), needTrim: true, renderMode: .alwaysOriginal)),
                       (name: "Hippo", thumb:  #imageLiteral(resourceName: "Hippo").scaleTo(size: CGSize(width: 100, height: 100), needTrim: true, renderMode: .alwaysOriginal)),
                       (name: "Giraffe", thumb:  #imageLiteral(resourceName: "Giraffe").scaleTo(size: CGSize(width: 100, height: 100), needTrim: true, renderMode: .alwaysOriginal)),
                       (name: "Giraffe", thumb:  #imageLiteral(resourceName: "Giraffe").scaleTo(size: CGSize(width: 100, height: 100), needTrim: true, renderMode: .alwaysOriginal)),
                       (name: "Giraffe", thumb:  #imageLiteral(resourceName: "Giraffe").scaleTo(size: CGSize(width: 100, height: 100), needTrim: true, renderMode: .alwaysOriginal)),
                       (name: "Jaguar", thumb:  #imageLiteral(resourceName: "Jaguar").scaleTo(size: CGSize(width: 100, height: 100), needTrim: true, renderMode: .alwaysOriginal)),
                       (name: "Jaguar", thumb:  #imageLiteral(resourceName: "Jaguar").scaleTo(size: CGSize(width: 100, height: 100), needTrim: true, renderMode: .alwaysOriginal)),
                       (name: "Zebra", thumb:  #imageLiteral(resourceName: "Zebra").scaleTo(size: CGSize(width: 100, height: 100), needTrim: true, renderMode: .alwaysOriginal)),
                       (name: "Zebra", thumb:  #imageLiteral(resourceName: "Zebra").scaleTo(size: CGSize(width: 100, height: 100), needTrim: true, renderMode: .alwaysOriginal)),
                       (name: "Tiger", thumb:  #imageLiteral(resourceName: "Tiger").scaleTo(size: CGSize(width: 100, height: 100), needTrim: true, renderMode: .alwaysOriginal)),
                       (name: "Tiger", thumb:  #imageLiteral(resourceName: "Tiger").scaleTo(size: CGSize(width: 100, height: 100), needTrim: true, renderMode: .alwaysOriginal)),
                       (name: "Lion", thumb:  #imageLiteral(resourceName: "Lion").scaleTo(size: CGSize(width: 100, height: 100), needTrim: true, renderMode: .alwaysOriginal)),
                       (name: "Lion", thumb:  #imageLiteral(resourceName: "Lion").scaleTo(size: CGSize(width: 100, height: 100), needTrim: true, renderMode: .alwaysOriginal))]
        
        for _ in 0...200 {
            guard let animal = animals.randomElement() else { continue }
            self.animals.append(animal)
        }
        
        collectionView?.register(ImageCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 100)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        collectionView.collectionViewLayout = layout
        
        navigationController?.delegate = self
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return animals.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ImageCell
        cell.imageView.image = animals[indexPath.row].thumb
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        selectedCell = cell
        let VC = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        VC.image = UIImage(named: animals[indexPath.row].name)
        navigationController?.pushViewController(VC, animated: true)
    }
}

extension ListViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch operation {
        case .push:
            guard let cell = selectedCell else { return nil }
            return PushToDetailAnimation(selectedCell: cell)
        case .pop:
            return nil
        case .none:
            return nil
        }
    }
}

private class PushToDetailAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    private let selectedCell: UICollectionViewCell
    
    init(selectedCell: UICollectionViewCell) {
        self.selectedCell = selectedCell
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.8
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        guard let fromVC = transitionContext.viewController(forKey: .from) as? ListViewController,
            let fromView = fromVC.view,
            let toVC = transitionContext.viewController(forKey: .to) as? DetailViewController,
            let toView = toVC.view else {
                return
        }
        
        let translateX = containerView.center.x - selectedCell.center.x
        let translateY = containerView.frame.width / 2 + 64 - selectedCell.center.y
        let scale = (containerView.frame.width - 50) / selectedCell.frame.width
        
        toView.alpha = 0
        fromView.alpha = 0.4
        containerView.addSubview(toView)
        containerView.addSubview(selectedCell)
        UIView.animateKeyframes(withDuration: transitionDuration(using: transitionContext), delay: 0, options: .layoutSubviews, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.7, animations: {
                self.selectedCell.transform = CGAffineTransform(translationX: translateX, y: translateY).scaledBy(x: scale, y: scale)
            })
            UIView.addKeyframe(withRelativeStartTime: 0.7, relativeDuration: 0.1, animations: {
                toView.alpha = 1
            })
        }) { (finish) in
            self.selectedCell.removeFromSuperview()
            fromView.alpha = 1
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}

