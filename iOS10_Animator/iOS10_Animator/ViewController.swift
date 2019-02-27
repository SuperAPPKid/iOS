//
//  ViewController.swift
//  iOS10_Animator
//
//  Created by Hank_Zhong on 2018/10/26.
//  Copyright © 2018 Hank_Zhong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var imageContainer: UIView!
    @IBOutlet var blurView: VisualEffectView!
    
    var blurAnimator: UIViewPropertyAnimator = UIViewPropertyAnimator(duration: 3, curve: .easeOut)
    
    var sliderAnimator: UIViewPropertyAnimator = UIViewPropertyAnimator(duration: 2, curve: .easeOut)
    
    let slider = UISlider()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        blurView.effect = nil
        blurView.blurRadius = 0
        
        imageContainer.clipsToBounds = true
        imageContainer.layer.borderWidth = 5
        imageContainer.layer.borderColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
        imageContainer.layer.cornerRadius = 50
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(imageViewPan(gesture:)))
        imageContainer.addGestureRecognizer(panGesture)
        
        
        let consoleVC = ConsoleViewController(parent: self, blurType: .light)
        
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print("🌶🌶🌶")
    }
    
    private var circleCenter: CGPoint = .zero
    private var blurRate: CGFloat = 0
    @objc func imageViewPan(gesture: UIPanGestureRecognizer) {
        guard let imageView = gesture.view else { return }
        switch gesture.state {
        case .began, .ended:
            circleCenter = imageView.center
            
            let completionRate = blurAnimator.fractionComplete
            let state = blurAnimator.state
            if blurAnimator.isRunning {
                if gesture.state == .began {
                    blurRate = 20 * (1 - completionRate)
                } else {
                    blurRate = 20 * completionRate
                }
            }
            
            blurAnimator.stopAnimation(false)
            blurAnimator.finishAnimation(at: .current)
            
            if gesture.state == .began {
                blurAnimator.addAnimations {
                    self.blurView.blurRadius = 20
                    self.imageContainer.transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
                }
            } else {
                blurAnimator.addAnimations {
                    self.blurView.blurRadius = 0
                    self.imageContainer.transform = .identity
                }
            }
            
            blurAnimator.addCompletion { (position) in
                if position == .current {
                    self.blurView.blurRadius = self.blurRate
                }
            }
            
            if state == .active {
                blurAnimator.pauseAnimation()
                blurAnimator.continueAnimation(withTimingParameters: nil, durationFactor: completionRate)
            } else {
                blurAnimator.pauseAnimation()
                blurAnimator.continueAnimation(withTimingParameters: nil, durationFactor: 1)
            }
        case .changed:
            let translation = gesture.translation(in: imageView)
            imageView.center = CGPoint(x: circleCenter.x + translation.x, y: circleCenter.y + translation.y)
        default:
            break
        }
    }
    
    private var pauseFlag: Bool = true
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if pauseFlag {
            sliderAnimator.pauseAnimation()
        } else {
            sliderAnimator.startAnimation()
        }
        pauseFlag.toggle()
    }
    
    @objc func test(sender: UISlider) {
        guard !sliderAnimator.isRunning else { return }
        sliderAnimator.fractionComplete = CGFloat(sender.value)
    }
    
    @objc func testSwitch(sender: UISwitch) {
        //if no animation or animation is finished
        print(sliderAnimator.state)
        if sliderAnimator.state == .inactive {
            if sender.isOn {
                sliderAnimator.addAnimations {
                    self.slider.setValue(1, animated: true)
                    self.imageContainer.transform = CGAffineTransform(scaleX: 2, y: 0.5).rotated(by: .pi)
                }
            } else {
                sliderAnimator.addAnimations {
                    self.slider.setValue(0, animated: true)
                    self.imageContainer.transform = .identity
                }
            }
            sliderAnimator.startAnimation()
        }
    }
    
    deinit {
        print("disappear")
    }
}

extension UIViewAnimatingState: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case .inactive:
            return "inactive"
        case .active:
            return "active"
        case .stopped:
            return "stopped"
        }
    }
    
}
