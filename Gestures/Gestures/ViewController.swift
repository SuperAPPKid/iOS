//
//  ViewController.swift
//  Gestures
//
//  Created by Hank_Zhong on 2018/8/21.
//  Copyright © 2018年 Hank_Zhong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let blueView: UIView = {
        let view = UIView(frame: .init(x: 50, y: 50, width: 350, height: 350))
        view.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        return view
    }()
    let greenView: ExpandTouchView = {
        let view = ExpandTouchView(name: "green", frame: .init(x: 50, y: 50, width: 250, height: 250))
        view.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        return view
    }()
    let pinkView: TouchView = {
        let view = TouchView(name: "pink", frame: .init(x: 100, y: 100, width: 150, height: 150))
        view.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let oneTap1 = UITapGestureRecognizer(target: self, action: #selector(oneSingleTap(sender:)))
        let oneTap2 = UITapGestureRecognizer(target: self, action: #selector(oneSingleTap(sender:)))
        
        greenView.addGestureRecognizer(oneTap1)
        pinkView.addGestureRecognizer(oneTap2)
        
        view.addSubview(blueView)
        blueView.addSubview(greenView)
        greenView.addSubview(pinkView)
    }
    
    @objc func oneSingleTap(sender: UITapGestureRecognizer) {
        let view = sender.view as! TouchView
        print("\(view.name!) oneSingleTap")
    }
}

