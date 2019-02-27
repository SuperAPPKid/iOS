//
//  File.swift
//  UIDynamicMaster
//
//  Created by Hank_Zhong on 2019/2/26.
//  Copyright © 2019 Hank_Zhong. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {
    let needSideViewContainStatusbar: Bool = false
    let rightSideVC: SideViewController = SideViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let sideContainerView = ContainerView()
        sideContainerView.frame = view.bounds
        sideContainerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(sideContainerView)
        
        rightSideVC.delegate = self
        sideContainerView.addSubview(rightSideVC.view)
    }
    
    override var shouldAutorotate: Bool {
        return topViewController?.shouldAutorotate ?? super.shouldAutorotate
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return topViewController?.supportedInterfaceOrientations ?? super.supportedInterfaceOrientations
    }
}

extension NavigationController: SideViewControllerDelegate {
    func sizeForRightSideView(_ controller: SideViewController) -> CGSize {
        let size = view.bounds.size
        return CGSize(width: min(size.width, size.height) / 3 * 2,
                      height: needSideViewContainStatusbar ? size.height : size.height - UIApplication.shared.statusBarFrame.height)
    }
    
}

class ContainerView: UIView {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard self.point(inside: point, with: event) else { return nil }
        for subView in subviews {
            if let hitView = subView.hitTest(convert(point, to: subView), with: event) {
                return hitView
            }
        }
        return nil
    }
}

protocol SideViewControllerDelegate: AnyObject {
    func sizeForRightSideView(_ controller: SideViewController) -> CGSize
}

class SideViewController: UIViewController {
    private var rightSideView: ContainerView = ContainerView()
    weak var delegate: SideViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        view.addSubview(rightSideView)
        rightSideView.backgroundColor = .white
        hideSideView(animate: false)
        
        view.isUserInteractionEnabled = false
    }
    
    var isToggleingSideView: Bool = false
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let rightSize = delegate?.sizeForRightSideView(self), !isToggleingSideView {
            let selfSize = view.bounds.size
            rightSideView.frame = CGRect(x: selfSize.width - rightSize.width,
                                         y: selfSize.height - rightSize.height,
                                         width: rightSize.width,
                                         height: rightSize.height)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if rightSideView.isHidden {
            showSideView(animate: true)
        } else {
            hideSideView(animate: true)
        }
    }
    
    func hideSideView(animate: Bool) {
        rightSideView.transform = .identity
        if animate {
            isToggleingSideView = true
            let distance = rightSideView.bounds.width
            
            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                self.rightSideView.transform = CGAffineTransform(translationX: distance, y: 0)
                self.view.backgroundColor = .clear
            }) { (position) in
                self.isToggleingSideView = false
                switch position {
                case .start:
                    self.rightSideView.transform = .identity
                    self.view.backgroundColor = #colorLiteral(red: 0.1921568662, green: 0.007843137719, blue: 0.09019608051, alpha: 0.4006314212)
                    self.rightSideView.isHidden = false
                case .end:
                    self.rightSideView.isHidden = true
                    break
                case .current:
                    break
                }
            }
        } else {
            rightSideView.transform = CGAffineTransform(translationX: rightSideView.bounds.width, y: 0)
            self.view.backgroundColor = .clear
            rightSideView.isHidden = true
        }
    }
    
    func showSideView(animate: Bool) {
        rightSideView.isHidden = false
        let distance = rightSideView.bounds.width
        rightSideView.transform = CGAffineTransform(translationX: distance, y: 0)
        
        if animate {
            isToggleingSideView = true
            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                self.rightSideView.transform = .identity
                self.view.backgroundColor = #colorLiteral(red: 0.1921568662, green: 0.007843137719, blue: 0.09019608051, alpha: 0.4006314212)
            }) { (position) in
                self.isToggleingSideView = false
                switch position {
                case .start:
                    self.rightSideView.transform = CGAffineTransform(translationX: distance, y: 0)
                    self.view.backgroundColor = .clear
                    self.rightSideView.isHidden = true
                case .end:
                    break
                case .current:
                    break
                }
            }
        } else {
            rightSideView.transform = .identity
            view.backgroundColor = #colorLiteral(red: 0.1921568662, green: 0.007843137719, blue: 0.09019608051, alpha: 0.4006314212)
        }
    }
}
