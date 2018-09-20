//
//  PushViewController.swift
//  DoSomeTransition
//
//  Created by Hank_Zhong on 2018/9/20.
//  Copyright © 2018年 Hank_Zhong. All rights reserved.
//

import UIKit

class PushViewController: UIViewController {
    @IBOutlet weak var pushBtn: RadiusButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.delegate = self
    }
    
    deinit {
        print("push deinit")
    }
    
    // MARK: - Navigation
    @IBAction func exit(for segue: UIStoryboardSegue, sender: Any?) {
    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }

}

extension PushViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let anim = MaskAnimation(operation: operation)
        anim.startRect = pushBtn.frame
        return anim
    }
}

private class MaskAnimation: NSObject, UIViewControllerAnimatedTransitioning, CAAnimationDelegate {
    private let duration: TimeInterval = 0.5
    private let operation: UINavigationController.Operation
    private var layerAnimCompleteCallback: ((Bool)->())?
    private weak var transitionContext: UIViewControllerContextTransitioning?
    var startRect: CGRect = CGRect.zero
    
    init(operation: UINavigationController.Operation) {
        self.operation = operation
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        self.transitionContext = transitionContext
        let containerView = transitionContext.containerView
        let fromVC = transitionContext.viewController(forKey: .from)
        let toVC = transitionContext.viewController(forKey: .to)
        guard let fromView = fromVC?.view, let toView = toVC?.view else { return }
        fromView.backgroundColor = [#colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1),#colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1),#colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0, alpha: 1),#colorLiteral(red: 0.5563425422, green: 0.9793455005, blue: 0, alpha: 1),#colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1),#colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1),#colorLiteral(red: 0.5818830132, green: 0.2156915367, blue: 1, alpha: 1)].randomElement()
        UIView.animate(withDuration: 0.3, delay: 0.025, usingSpringWithDamping: 0.8, initialSpringVelocity: 5, options: .curveEaseInOut, animations: {
            toView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }) { (finish) in
            UIView.animate(withDuration: 0.2, animations: {
                toView.transform = .identity
            })
        }
        
        containerView.addSubview(toView)
        
        let radius = (containerView.frame.width * containerView.frame.width + containerView.frame.height * containerView.frame.height).squareRoot() / 2
        let initialPath = UIBezierPath(rect: .zero)
        let finalPath = UIBezierPath(roundedRect: CGRect(origin: .init(x: -radius, y: -radius), size: .init(width: radius * 2, height: radius * 2)), cornerRadius: radius)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = finalPath.cgPath
        shapeLayer.position = .init(x: startRect.midX, y: startRect.midY)
        
        let shapeAnim = CABasicAnimation(keyPath: "path")
        shapeAnim.duration = transitionDuration(using: transitionContext)
        shapeAnim.fromValue = initialPath.cgPath
        shapeAnim.toValue = finalPath.cgPath
        shapeAnim.timingFunction = CAMediaTimingFunction(name: .easeOut)
        shapeAnim.delegate = self
        shapeLayer.add(shapeAnim, forKey: "shape")
        toView.layer.mask = shapeLayer
        
        switch operation {
        case .none:
            break
        case .push:
            break
        case .pop:
            break
        }
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        transitionContext?.viewController(forKey: .to)?.view.layer.mask = nil
        transitionContext?.completeTransition(true)
    }
}
