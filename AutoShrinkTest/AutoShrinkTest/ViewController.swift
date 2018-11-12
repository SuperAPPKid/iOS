//
//  ViewController.swift
//  AutoShrinkTest
//
//  Created by Hank_Zhong on 2018/10/29.
//  Copyright © 2018 Hank_Zhong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var containerH: NSLayoutConstraint!
    @IBOutlet weak var containerW: NSLayoutConstraint!
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var redView: UIView!
    let blueView: UIView = {
        let view = UIView(frame: CGRect(x: 15, y: 100, width: 45, height: 45))
        view.backgroundColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
        return view
    }()
    var isRotate: Bool = false
    var autoShrinkMask:UIView.AutoresizingMask = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        redView.translatesAutoresizingMaskIntoConstraints = false
        blueView.translatesAutoresizingMaskIntoConstraints = false
        blueView.autoresizingMask = []
        redView.autoresizingMask = []
        containerView.addSubview(blueView)
    }
    
    @IBAction func rotateClick(_ sender: UIButton) {
        isRotate.toggle()
        blueView.autoresizingMask = autoShrinkMask
        redView.autoresizingMask = autoShrinkMask
        containerH.constant = isRotate ? 140:280
        containerW.constant = isRotate ? 100:200
    }
    
    @IBAction func toogleSwitch(_ sender: UISwitch) {
        print("\(sender.tag) - \(sender.isOn ? "on":"off")")
        switch sender.tag {
        case 0:
            redView.translatesAutoresizingMaskIntoConstraints = sender.isOn
            blueView.translatesAutoresizingMaskIntoConstraints = sender.isOn
            break
        case 1:
            if sender.isOn {
                autoShrinkMask.insert(.flexibleLeftMargin)
            } else {
                autoShrinkMask.remove(.flexibleLeftMargin)
            }
            break
        case 2:
            if sender.isOn {
                autoShrinkMask.insert(.flexibleRightMargin)
            } else {
                autoShrinkMask.remove(.flexibleRightMargin)
            }
            break
        case 3:
            if sender.isOn {
                autoShrinkMask.insert(.flexibleTopMargin)
            } else {
                autoShrinkMask.remove(.flexibleTopMargin)
            }
            break
        case 4:
            if sender.isOn {
                autoShrinkMask.insert(.flexibleBottomMargin)
            } else {
                autoShrinkMask.remove(.flexibleBottomMargin)
            }
            break
        case 5:
            if sender.isOn {
                autoShrinkMask.insert(.flexibleWidth)
            } else {
                autoShrinkMask.remove(.flexibleWidth)
            }
            break
        case 6:
            if sender.isOn {
                autoShrinkMask.insert(.flexibleHeight)
            } else {
                autoShrinkMask.remove(.flexibleHeight)
            }
            break
        default:
            fatalError()
        }
    }
    
}

