//
//  MVVMViewModel.swift
//  MVP+MVVM
//
//  Created by Hank_Zhong on 2018/6/20.
//  Copyright © 2018年 Hank_Zhong. All rights reserved.
//

import UIKit

class MVVM_HomeViewModel:MVVM_HomeViewProtocol {
    let data = Model.shared.people
    
    var showResponse:((String)->())?
    var responseText:String = "" {
        didSet {
            self.showResponse?(responseText)
        }
    }
    
    func getTextfieldText(text: String?) {
        guard let text = text else { return }
        let index = Int(text)
        
        if let index = index,index < data.count {
            responseText = "\(data[index].name) - \(data[index].age)"
        } else {
            responseText = "~Error~"
        }
    }
}
