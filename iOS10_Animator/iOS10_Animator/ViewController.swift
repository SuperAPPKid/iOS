//
//  ViewController.swift
//  iOS10_Animator
//
//  Created by Hank_Zhong on 2018/10/26.
//  Copyright © 2018 Hank_Zhong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var blurImageView: UIImageView!
    lazy var blurView: UIVisualEffectView = {
        let view = UIVisualEffectView(frame: self.blurImageView.bounds)
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.blurImageView.addSubview(view)
        return view
    }()
    lazy var animator: UIViewPropertyAnimator = {
        let anim = UIViewPropertyAnimator(duration: 1, curve: .easeOut)
        anim.pausesOnCompletion = true
        anim.addAnimations {
            self.blurView.effect = UIBlurEffect(style: .light)
            self.blurImageView.transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
        }
        return anim
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let consoleVC = ConsoleViewController(parent: self, blurType: .light)
        
        let slider = UISlider()
        slider.thumbTintColor = .red
        slider.tintColor = .black
        slider.addTarget(self, action: #selector(test(sender:)), for: .valueChanged)
        
        let mySwitch = UISwitch()
        mySwitch.thumbTintColor = .red
        mySwitch.onTintColor = .black
        mySwitch.addTarget(self, action: #selector(testSwitch(sender:)), for: .valueChanged)
        
        consoleVC.addAction(action: ConsoleAction(title: "Slider", control: slider, preferColor: #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)))
        consoleVC.addAction(action: ConsoleAction(title: "Switch", control: mySwitch, preferColor: #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)))
        
        view.addSubview(consoleVC.view)
    }
    
    @objc func test(sender: UISlider) {
        animator.fractionComplete = CGFloat(sender.value)
    }
    
    @objc func testSwitch(sender: UISwitch) {
        if sender.isOn {
            animator.pauseAnimation()
            animator.isReversed = false
            animator.startAnimation()
        } else {
            animator.pauseAnimation()
            animator.isReversed = true
            animator.startAnimation()
        }
    }
    
    deinit {
        print("disappear")
    }
}

