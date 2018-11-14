//
//  LabelViewModel.swift
//  MVVM_Practice
//
//  Created by Hank_Zhong on 2018/11/14.
//  Copyright © 2018 Hank_Zhong. All rights reserved.
//

import UIKit

class LabelViewModel {
    var textElement: ObserveElement<String>
    var colorElement: ObserveElement<UIColor>
    var timer:Timer?
    init(milliseconds: UInt) {
        textElement = ObserveElement("READY")
        colorElement = ObserveElement(UIColor.white, delayMilliSeconds: milliseconds)
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.textElement.value = ["GOGOGO","HELLO","WORLD"].randomElement()!
            self.colorElement.value = [#colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1),#colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1),#colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1),#colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1),#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1),#colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1),#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 0.7978649401),#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1),#colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1),#colorLiteral(red: 0.3084011078, green: 0.5618229508, blue: 0, alpha: 1),#colorLiteral(red: 0, green: 0.9914394021, blue: 1, alpha: 1),#colorLiteral(red: 1, green: 0.1857388616, blue: 0.5733950138, alpha: 1),#colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0, alpha: 1),#colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1)].randomElement()!
        }
    }
}
