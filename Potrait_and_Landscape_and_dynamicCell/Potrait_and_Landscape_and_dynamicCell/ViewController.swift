//
//  ViewController.swift
//  Potrait_and_Landscape_and_dynamicCell
//
//  Created by zhong on 2018/7/17.
//  Copyright © 2018年 zhong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func overrideTraitCollection(forChildViewController childViewController: UIViewController) -> UITraitCollection? {
        var traitCollections:[UITraitCollection] = []
        if UIDevice.current.userInterfaceIdiom == .pad && UIDevice.current.orientation.isPortrait {
            traitCollections = [UITraitCollection(horizontalSizeClass: .compact),UITraitCollection(verticalSizeClass: .regular)]
        } else {
            traitCollections = [UITraitCollection(horizontalSizeClass: .unspecified),UITraitCollection(verticalSizeClass: .unspecified)]
        }
        return UITraitCollection(traitsFrom: traitCollections)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
