//
//  CustomActionSheet.swift
//  
//
//  Created by Hank_Zhong on 2018/7/6.
//

import UIKit

enum CustomActionStyle:Int {
    case `default`
    case sort
    case ok
}

struct CustomAction {
    let style:CustomActionStyle
    let text:String
}

class CustomActionSheet: UIViewController {
    var rowHeight:CGFloat {
        get {
            return CGFloat(actions.count * 80)
        }
    }
    private(set) var actions:[CustomAction] = []
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = Device.IS_IPAD ? .popover : .custom
        self.transitioningDelegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let stackView = UIStackView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: rowHeight))
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        
        if Device.IS_IPAD {
            self.preferredContentSize = CGSize(width: 400, height: rowHeight)
            stackView.frame = CGRect(x: 0, y: 0, width: 400, height: rowHeight)
        } else {
            view.frame = CGRect(x: 10, y: view.frame.height - rowHeight, width: view.frame.width - 20, height: rowHeight + 20)
            view.layer.cornerRadius = 20
            view.clipsToBounds = true
        }
        
        for action in actions {
            let button = UIButton(type: .system)
            button.setTitle(action.text, for: .normal)
            switch action.style {
            case .default :
                button.backgroundColor = .red
                break
            case .sort :
                button.backgroundColor = .yellow
                break
            case .ok :
                button.backgroundColor = .blue
                break
            }
            stackView.addArrangedSubview(button)
        }
        view.addSubview(stackView)
    }
    
    @objc func dism() {
        if let popoverVC = popoverPresentationController,
            let dismiss = popoverVC.delegate?.popoverPresentationControllerShouldDismissPopover {
            if !dismiss(popoverVC) {return}
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func add(action:CustomAction) {
        actions.append(action)
    }
}

extension CustomActionSheet:UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return TestTransitioning(height: rowHeight)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return TestTransitioning(height: rowHeight)
    }
    
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return nil
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return nil
    }
    
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return TestPrensentationController(presentedViewController: presented, presenting: presenting)
    }
    
}
