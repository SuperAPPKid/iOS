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
    @IBOutlet weak var toolBoxBottom: NSLayoutConstraint!
    
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
        let changeWidthBtn = UIBarButtonItem(title: "線寬", style: .plain, target: self, action: #selector(startPaintToolsClick(_:))).with(tag: 2)
        let changeColorBtn = UIBarButtonItem(title: "顏色", style: .plain, target: self, action: #selector(startPaintToolsClick(_:))).with(tag: 3)
        let changeAlphaBtn = UIBarButtonItem(title: "不透明度", style: .plain, target: self, action: #selector(startPaintToolsClick(_:))).with(tag: 4)
        let shapeBtn = UIBarButtonItem(title: "形狀", style: .plain, target: self, action: #selector(startPaintToolsClick(_:))).with(tag: 5)
        startPaintTools.append(contentsOf: [closeBoardBtn, trashBtn, changeWidthBtn, changeColorBtn, changeAlphaBtn, shapeBtn])
        
        paintToolbox.setItems(beforePaintTools, animated: true)
        
        let oneTap = UITapGestureRecognizer(target: self, action: #selector(oneTap(sender:)))
        oneTap.numberOfTouchesRequired = 1
        
        view.addGestureRecognizer(oneTap)
    }
    
    @objc func oneTap(sender: UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.5) {
            self.toolBoxBottom.constant = self.toolBoxBottom.constant == 0 ? -50 : 0  ///use storyboard
            
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
        case 2:
            let alertController = UIAlertController(title: "線寬", message: nil, preferredStyle: .actionSheet)
            alertController.addAction(.init(title: "3(預設)", style: .default, handler: { _ in self.bottomView.paintView.preferWidth = 3}))
            alertController.addAction(.init(title: "5", style: .default, handler: { _ in self.bottomView.paintView.preferWidth = 5}))
            alertController.addAction(.init(title: "10", style: .default, handler: { _ in self.bottomView.paintView.preferWidth = 10}))
            alertController.addAction(.init(title: "20", style: .default, handler: { _ in self.bottomView.paintView.preferWidth = 20}))
            alertController.addAction(.init(title: "40", style: .default, handler: { _ in self.bottomView.paintView.preferWidth = 40}))
            alertController.popoverPresentationController?.barButtonItem = sender
            present(alertController, animated: true, completion: nil)
            break
        case 3:
            let alertController = UIAlertController(title: "顏色", message: nil, preferredStyle: .actionSheet)
            alertController.addAction(.init(title: "紅", style: .default, handler: { _ in self.bottomView.paintView.preferColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)}))
            alertController.addAction(.init(title: "橙", style: .default, handler: { _ in self.bottomView.paintView.preferColor = #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1)}))
            alertController.addAction(.init(title: "黃", style: .default, handler: { _ in self.bottomView.paintView.preferColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)}))
            alertController.addAction(.init(title: "綠", style: .default, handler: { _ in self.bottomView.paintView.preferColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)}))
            alertController.addAction(.init(title: "藍", style: .default, handler: { _ in self.bottomView.paintView.preferColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)}))
            alertController.addAction(.init(title: "紫", style: .default, handler: { _ in self.bottomView.paintView.preferColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)}))
            alertController.addAction(.init(title: "黑", style: .default, handler: { _ in self.bottomView.paintView.preferColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)}))
            alertController.popoverPresentationController?.barButtonItem = sender
            present(alertController, animated: true, completion: nil)
            break
        case 4:
            let alertController = UIAlertController(title: "不透明度", message: nil, preferredStyle: .actionSheet)
            alertController.addAction(.init(title: "0.8(預設)", style: .default, handler: { _ in self.bottomView.paintView.preferAlpha = 0.8}))
            alertController.addAction(.init(title: "0.5", style: .default, handler: { _ in self.bottomView.paintView.preferAlpha = 0.5}))
            alertController.addAction(.init(title: "0.2", style: .default, handler: { _ in self.bottomView.paintView.preferAlpha = 0.2}))
            alertController.popoverPresentationController?.barButtonItem = sender
            present(alertController, animated: true, completion: nil)
            break
        case 5:
            let alertController = UIAlertController(title: "形狀", message: nil, preferredStyle: .actionSheet)
            alertController.addAction(.init(title: "曲線(預設)", style: .default, handler: { _ in self.bottomView.paintView.preferShape = .曲線}))
            alertController.addAction(.init(title: "直線", style: .default, handler: { _ in self.bottomView.paintView.preferShape = .直線}))
            alertController.addAction(.init(title: "曲線(虛線)", style: .default, handler: { _ in self.bottomView.paintView.preferShape = .虛線曲}))
            alertController.addAction(.init(title: "直線(虛線)", style: .default, handler: { _ in self.bottomView.paintView.preferShape = .虛線直}))
            alertController.addAction(.init(title: "橡皮擦", style: .default, handler: { _ in self.bottomView.paintView.preferShape = .橡皮擦}))
            alertController.popoverPresentationController?.barButtonItem = sender
            present(alertController, animated: true, completion: nil)
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
        bottomView.paintView.clear()
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
