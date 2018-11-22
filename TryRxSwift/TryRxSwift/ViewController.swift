//
//  ViewController.swift
//  TryRxSwift
//
//  Created by Hank_Zhong on 2018/11/22.
//  Copyright © 2018 Hank_Zhong. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        Variable
        
//        UITextView().rx.text
//        UITextView().hz.num
    }
}


struct Magic<Base> {
    let base: Base
}
extension Magic where Base: UITextView {
    var num: Int {
        return 100
    }
}
protocol Testable {
    associatedtype T
    var hz: Magic<Self.T> { get }
}
extension Testable {
    var hz: Magic<Self> {
        return Magic(base: self)
    }
}
extension NSObject: Testable{}
