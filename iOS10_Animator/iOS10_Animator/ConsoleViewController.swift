//
//  ConsoleViewController.swift
//  iOS10_Animator
//
//  Created by Hank_Zhong on 2018/10/26.
//  Copyright © 2018 Hank_Zhong. All rights reserved.
//

import UIKit

class ConsoleViewController: UIViewController {
    private unowned let parentVC: UIViewController
    
    var blurType: UIBlurEffect.Style
    private lazy var blurView: UIVisualEffectView = { return UIVisualEffectView(effect: UIBlurEffect(style: blurType) ) }()
    private let maskView: UIView = GradientView(autoSize: [.flexibleHeight, .flexibleWidth])
    
    private var scrollView: UIScrollView = UIScrollView()
    
    private var actions: [ConsoleAction<UIControl>] = []
    private var actionViews: [ConsoleActionView<UIControl>] = []
    
    private let barView: UIView = ExpandTouchView()
    private var isExpanded: Bool = false
    
    var desireHeight: CGFloat = 250
    private var cellHeight: CGFloat = 65
    private var padding: CGFloat = 20
    private var buffer: CGFloat = 45
    
    init(parent: UIViewController, blurType: UIBlurEffect.Style) {
        self.parentVC = parent
        self.blurType = blurType
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        parentVC.addChild(self)
        
        view.clipsToBounds = true
        view.layer.cornerRadius = 35
        
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        view.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        
        scrollView.autoresizingMask = [.flexibleWidth]
        scrollView.frame.size.height = desireHeight
        
        view.addSubview(blurView)
        blurView.contentView.addSubview(scrollView)
        blurView.contentView.mask = maskView
        
        view.addSubview(barView)
        barView.backgroundColor = UIColor.white
        barView.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleBottomMargin]
        barView.clipsToBounds = true
        barView.layer.cornerRadius = 3
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panBarView(_:)))
        barView.addGestureRecognizer(panGesture)
        
        for action in actions {
            let actionView = ConsoleActionView(title: action.title, control: action.control, color: action.preferColor)
            scrollView.addSubview(actionView)
            actionViews.append(actionView)
        }
    }
    
    @objc private func panBarView(_ gesture:UIPanGestureRecognizer) {
        let translate = gesture.translation(in: view).y
        gesture.setTranslation(CGPoint(x: 0, y: 0), in: view)
        switch gesture.state {
        case .changed:
            let isBelowBuffer = parentVC.view.frame.height - view.frame.origin.y <= 45
            let isAboveDesire = parentVC.view.frame.height - view.frame.origin.y >= 45 + desireHeight
            if (isBelowBuffer && translate > 0) || (isAboveDesire && translate < 0) {
                view.center.y += translate * 0.1
            } else {
                view.center.y += translate
            }
        case .ended, .cancelled, .failed:
            let isAroundBuffer = parentVC.view.frame.height - view.frame.origin.y <= 90
            let isAroundDesire = parentVC.view.frame.height - view.frame.origin.y >= desireHeight - 90
            if isExpanded {
                isExpanded = isAroundDesire
            } else {
                isExpanded = !isAroundBuffer
            }
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 5, options: .curveEaseOut, animations: {
                self.view.frame.origin.y = self.isExpanded ? self.parentVC.view.frame.height - self.desireHeight : self.parentVC.view.frame.height - 45
            }, completion: nil)
            break
        default:
            break
        }
    }
    
    override func viewDidLayoutSubviews() {
        
        view.frame = CGRect(x: 0, y: parentVC.view.frame.height - 45, width: parentVC.view.frame.width, height: parentVC.view.frame.height)
        blurView.frame = view.bounds
        maskView.frame = view.bounds
        barView.center = CGPoint(x: view.center.x, y: 18)
        barView.frame.size = CGSize(width: 120, height: 6)
        let width = view.bounds.width
        scrollView.contentSize = CGSize(width: width, height: CGFloat(actions.count) * (cellHeight + padding) + padding + 25)
        scrollView.contentInset = .zero
        scrollView.contentOffset = .zero
        
        for (index, actionView) in actionViews.enumerated() {
            actionView.configureLayout(frame: CGRect(x: padding, y: (cellHeight + padding) * CGFloat(index) + padding + 25, width: width - padding * 2, height: cellHeight))
        }
    }
    
    func addAction(action: ConsoleAction<UIControl>) {
        actions.append(action)
    }
    
    deinit {
        print("Console DEAD")
    }
}

fileprivate class ConsoleActionView<T:UIControl>: UIView {
    let titleView: UIVisualEffectView
    unowned let controlElement: T
    
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
    
    init(autoSize: AutoresizingMask) {
        super.init(frame: .zero)
        self.autoresizingMask = autoSize
        self.isUserInteractionEnabled = false
        self.clipsToBounds = true
        
        gradientLayer?.colors = [UIColor(white: 0, alpha: 0.1).cgColor, UIColor(white: 0, alpha: 1).cgColor]
        gradientLayer?.locations = [0.025, 0.1]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

fileprivate class ExpandTouchView: UIView {
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if bounds.insetBy(dx: 0, dy: -22.5).contains(point) {
            return true
        } else {
            return false
        }
    }
}
