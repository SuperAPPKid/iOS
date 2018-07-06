//
//  MVPPresenter.swift
//  MVP+MVVM
//
//  Created by Hank_Zhong on 2018/6/20.
//  Copyright © 2018年 Hank_Zhong. All rights reserved.
//

import UIKit

class MVP_HomePresenter: MVP_HomePresenterProtocol {
    unowned let view:MVP_HomeViewController
    let data = Model.shared.people
    
    init(view:MVP_HomeViewController) {
        self.view = view
    }
    
    func showAlert(text:String?) {
        guard let text = text else { return }
        let index = Int(text)
        var ansStr:String
        
        if let index = index,index < data.count {
            ansStr = "\(data[index].name) - \(data[index].age)"
        } else {
            ansStr = "~Error~"
        }
        
        let alert = UIAlertController(title: ansStr, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.view.present(alert, animated: true, completion: nil)
    }
}
