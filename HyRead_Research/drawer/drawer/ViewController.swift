//
//  ViewController.swift
//  drawer
//
//  Created by Hank_Zhong on 2018/12/3.
//  Copyright © 2018 Hank_Zhong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var paintToolbox: UIToolbar!
    @IBOutlet weak var toolBoxHeight: NSLayoutConstraint!
    
    var beforePaintTools: [UIBarButtonItem] = []
    var startPaintTools: [UIBarButtonItem] = []
    
    lazy var bottomView: BottomView = BottomView().shrink([.flexibleWidth, .flexibleHeight]).fill(scrollView).add(to: scrollView)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.maximumZoomScale = 4
        scrollView.delegate = self
        scrollView.panGestureRecognizer.minimumNumberOfTouches = 2
        scrollView.delaysContentTouches = false

        let addBoardBtn = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(beforePaintToolsClick(_:))).with(tag: 0)
        let changeImageBtn = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(beforePaintToolsClick(_:))).with(tag: 1)
        beforePaintTools.append(contentsOf: [addBoardBtn, changeImageBtn])
        
        let closeBoardBtn = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(startPaintToolsClick(_:))).with(tag: 0)
        let trashBtn = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(startPaintToolsClick(_:))).with(tag: 1)
        startPaintTools.append(contentsOf: [closeBoardBtn, trashBtn])
        
        paintToolbox.setItems(beforePaintTools, animated: true)
        
        let oneTap = UITapGestureRecognizer(target: self, action: #selector(oneTap(sender:)))
        oneTap.numberOfTouchesRequired = 1
        
        view.addGestureRecognizer(oneTap)
    }
    
    @objc func oneTap(sender: UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.5) {
            self.toolBoxHeight.constant = self.toolBoxHeight.constant == 0 ? 50 : 0  ///use storyboard
            ///use code
//            self.paintToolbox.constraints.forEach { (constraint) in
//                if constraint.firstAnchor === self.paintToolbox.heightAnchor {
//                    print(constraint.debugDescription)
//                    constraint.constant = constraint.constant == 0 ? 50 : 0
//                    self.view.layoutIfNeeded()
//                }
//            }
            self.view.layoutIfNeeded()
        }
    }

    @objc func beforePaintToolsClick(_ sender: UIBarButtonItem) {
        switch sender.tag {
        case 0:
            bottomView.togglePaintBoard { visible in
                self.paintToolbox.setItems(startPaintTools, animated: true)
            }
            break
        case 1:
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .photoLibrary
            imagePicker.delegate = self
            present(imagePicker, animated: true, completion: nil)
            break
        default:
            break
        }
    }
    
    @objc func startPaintToolsClick(_ sender: UIBarButtonItem) {
        switch sender.tag {
        case 0:
            bottomView.togglePaintBoard { visible in
                scrollView.setZoomScale(1, animated: true)
                paintToolbox.setItems(beforePaintTools, animated: true)
            }
            break
        case 1:
            bottomView.paintView.clear()
            break
        default:
            break
        }
    }
}

extension ViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else {
            fatalError()
        }
        self.bottomView.image = image
        dismiss(animated: true)
    }
}

extension ViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return bottomView
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        scrollView.setZoomScale(scale, animated: true)
    }
}

extension UIBarButtonItem {
    func with(tag: Int) -> UIBarButtonItem {
        self.tag = tag
        return self
    }
}



protocol UIViewExtendable {
    func add(to view: UIView) -> Self
    func fill(_ view: UIView) -> Self
    func shrink(_ shrink: UIView.AutoresizingMask) -> Self
    func setBackgroundColor(_ color: UIColor) -> Self
}

extension UIViewExtendable where Self : UIView {
    func add(to view: UIView) -> Self {
        view.addSubview(self)
        return self
    }
    
    func fill(_ view: UIView) -> Self {
        self.frame = view.bounds
        return self
    }
    
    func shrink(_ shrink: AutoresizingMask) -> Self {
        self.autoresizingMask = shrink
        return self
    }
    
    func setBackgroundColor(_ color: UIColor) -> Self {
        self.backgroundColor = color
        return self
    }
}

extension UIView: UIViewExtendable {}

extension UIImage {
    ///縮圖
    func scaleTo(size: CGSize, needTrim: Bool, renderMode: UIImage.RenderingMode) -> UIImage? {
        //開啟畫布
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        
        //判斷使用縮放比例
        let imageHeightScale = size.height / self.size.height
        let imageWidthScale = size.width / self.size.width
        let usingScale = needTrim ? max(imageHeightScale, imageWidthScale):min(imageHeightScale, imageWidthScale)
        
        //判斷圖片於畫布上的位置
        let imageNewHeight = self.size.height * usingScale
        let imageNewWidth = self.size.width * usingScale
        let usingTranslateX = size.width - imageNewWidth
        let usingTranslateY = size.height - imageNewHeight
        
        //繪製
        self.draw(in: CGRect(x: usingTranslateX / 2, y: usingTranslateY / 2, width: imageNewWidth, height: imageNewHeight))
        let image = UIGraphicsGetImageFromCurrentImageContext()?.withRenderingMode(renderMode)
        
        //關閉畫布回收記憶體
        UIGraphicsEndImageContext()
        
        return image
    }
}
