//
//  TestTextField.swift
//  Gestures
//
//  Created by zhong on 2019/1/10.
//  Copyright © 2019 Hank_Zhong. All rights reserved.
//

import UIKit

class TestTextField: UITextField {
    override func becomeFirstResponder() -> Bool {
//        let ok = super.becomeFirstResponder()
        let ok = true
        return ok
    }
}
