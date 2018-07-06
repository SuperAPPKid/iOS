//
//  MVVMViewModel.swift
//  MVP+MVVM
//
//  Created by Hank_Zhong on 2018/6/20.
//  Copyright © 2018年 Hank_Zhong. All rights reserved.
//

import UIKit

struct MVVM_HomeViewModel {
    let data = Model.shared.people
    
    var responseTextDidSet:((String)->())?
    var responseText:String? {
        didSet {
            guard let text = responseText else { return }
            let index = Int(text)
            
            if let index = index,index < data.count {
                responseTextDidSet?("\(data[index].name) - \(data[index].age)")
            } else {
                responseTextDidSet?( "~Error~")
            }
        }
    }
    
}
