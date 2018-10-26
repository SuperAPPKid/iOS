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
    private let fixedWidth: Int = 300
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentInset = .zero
        scrollView.contentOffset = .zero
        
        view.addSubview(scrollView)
        for action in actions {
            let actionView = ConsoleActionView(title: action.title, control: action.control)
            scrollView.addSubview(actionView)
            actionViews.append(actionView)
        }
    }
    
    override func viewDidLayoutSubviews() {
        scrollView.frame = view.bounds
        let width = Int(view.bounds.width)
        scrollView.contentSize = CGSize(width: width, height: 10 + actions.count * 90)
        for (index, actionView) in actionViews.enumerated() {
            actionView.configureLayout(frame: CGRect(x: 10, y: 90 * index + 10, width: width - 20, height: 80))
        }
    }
    
    func addAction(action: ConsoleAction<UIControl>) {
        actions.append(action)
    }
}

fileprivate class ConsoleActionView<T:UIControl>: UIView {
    let titleLabel: UILabel
    let controlElement: T
    
    init(title: String, control: T) {
        titleLabel = {
            let label = UILabel()
            label.text = title
            label.font = UIFont.boldSystemFont(ofSize: 18)
            label.textAlignment = .center
            label.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
            return label
        }()
        controlElement = control
        
        super.init(frame: .zero)
        
        addSubview(titleLabel)
        addSubview(controlElement)
        backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
    }
    
    func configureLayout(frame: CGRect) {
        self.frame = frame
        titleLabel.frame.size = CGSize(width: frame.size.width * 0.3, height: frame.size.height * 0.8)
        titleLabel.center = CGPoint(x: frame.size.width * 0.2, y: frame.size.height * 0.5)
        controlElement.frame.size = CGSize(width: frame.size.width * 0.5, height: frame.size.height * 0.8)
        controlElement.center = CGPoint(x: frame.size.width * 0.65, y: frame.size.height * 0.5)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
