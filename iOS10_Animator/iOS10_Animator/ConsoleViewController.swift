//
//  ConsoleViewController.swift
//  iOS10_Animator
//
//  Created by Hank_Zhong on 2018/10/26.
//  Copyright © 2018 Hank_Zhong. All rights reserved.
//

import UIKit

class ConsoleViewController: UIViewController {
    private var scrollView: UIScrollView = UIScrollView()
    private var actions: [ConsoleAction<UIControl>] = []
    private var actionViews: [ConsoleActionView<UIControl>] = []
    private var cellHeight: CGFloat = 65
    private var padding: CGFloat = 20
    private let blurView: UIVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    private let topMask: UIView = GradientView(autoSize: [.flexibleTopMargin], reverse: false)
    private let bottomMask: UIView = GradientView(autoSize: [.flexibleBottomMargin], reverse: true)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentInset = .zero
        scrollView.contentOffset = .zero
        
        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurView)
        blurView.contentView.addSubview(scrollView)
        view.addSubview(topMask)
        view.addSubview(bottomMask)
        
        for action in actions {
            let actionView = ConsoleActionView(title: action.title, control: action.control, color: action.preferColor)
            scrollView.addSubview(actionView)
            actionViews.append(actionView)
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    override func viewDidLayoutSubviews() {
        blurView.frame = view.bounds
        let width = view.bounds.width
        let height = view.bounds.height
        topMask.frame = CGRect(x: 0, y: 0, width: width, height: height / 2)
        bottomMask.frame = CGRect(x: 0, y: height - height / 2, width: width, height: height / 2)
        scrollView.contentSize = CGSize(width: width, height: CGFloat(actions.count) * (cellHeight + padding) + padding)
        for (index, actionView) in actionViews.enumerated() {
            actionView.configureLayout(frame: CGRect(x: padding, y: (cellHeight + padding) * CGFloat(index) + padding, width: width - padding * 2, height: cellHeight))
        }
    }
    
    func addAction(action: ConsoleAction<UIControl>) {
        actions.append(action)
    }
    
}

fileprivate class ConsoleActionView<T:UIControl>: UIView {
    let titleView: UIVisualEffectView
    let controlElement: T
    
    init(title: String, control: T, color: UIColor) {
        titleView = {
            let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
            blurView.clipsToBounds = true
            let vibrancyView = UIVisualEffectView(effect: UIVibrancyEffect(blurEffect: UIBlurEffect(style: .dark)))
            vibrancyView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
            blurView.contentView.addSubview(vibrancyView)
            let label = UILabel(frame: blurView.bounds)
            label.autoresizingMask = [.flexibleHeight, .flexibleWidth]
            label.text = title
            label.textColor = .white
            label.font = UIFont.boldSystemFont(ofSize: 18)
            label.textAlignment = .center
            vibrancyView.contentView.addSubview(label)
            return blurView
        }()
        controlElement = control
        
        super.init(frame: .zero)
        
        addSubview(titleView)
        addSubview(controlElement)
        clipsToBounds = true
        backgroundColor = UIColor(cgColor: color.cgColor.copy(alpha: 0.5) ?? color.cgColor)
        layer.borderWidth = 2
        layer.borderColor = color.cgColor.copy(alpha: 1)
    }
    
    func configureLayout(frame: CGRect) {
        self.frame = frame
        titleView.layer.cornerRadius = frame.size.height * 0.35
        layer.cornerRadius = frame.size.height * 0.25
        titleView.frame.size = CGSize(width: frame.size.width * 0.3, height: frame.size.height * 0.7)
        titleView.center = CGPoint(x: frame.size.width * 0.2, y: frame.size.height * 0.5)
        controlElement.frame.size = CGSize(width: frame.size.width * 0.5, height: frame.size.height * 0.5)
        controlElement.center = CGPoint(x: frame.size.width * 0.7, y: frame.size.height * 0.5)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

fileprivate class GradientView: UIView {
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    var gradientLayer: CAGradientLayer? {
        return self.layer as? CAGradientLayer
    }
    
    init(autoSize: AutoresizingMask, reverse: Bool) {
        super.init(frame: .zero)
        self.isUserInteractionEnabled = false
        self.autoresizingMask = autoSize
        gradientLayer?.colors = [UIColor(white: 0, alpha: 0.3).cgColor, UIColor(white: 0, alpha: 0).cgColor]
        gradientLayer?.locations = [0.2, 0.5]
        if !reverse {
            gradientLayer?.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer?.endPoint = CGPoint(x: 0, y: 1)
        } else {
            gradientLayer?.startPoint = CGPoint(x: 0, y: 1)
            gradientLayer?.endPoint = CGPoint(x: 0, y: 0)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
