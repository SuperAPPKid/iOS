//
//  ViewController.swift
//  MVVM_Practice
//
//  Created by Hank_Zhong on 2018/11/13.
//  Copyright © 2018 Hank_Zhong. All rights reserved.
//

import UIKit

class ViewController: UIViewController, ObserveElementDelegate {
    var labelViewModels:[LabelViewModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        func createLabel(frame: CGRect) -> UILabel {
            let label = UILabel(frame: frame)
            label.font = UIFont.boldSystemFont(ofSize: 18)
            return label
        }

        let label1 = createLabel(frame: .init(x: 50, y: 100, width: 100, height: 100))
        let label2 = createLabel(frame: .init(x: 170, y: 100, width: 100, height: 100))
        let label3 = createLabel(frame: .init(x: 50, y: 220, width: 100, height: 100))
        let label4 = createLabel(frame: .init(x: 170, y: 220, width: 100, height: 100))
        [label1, label2, label3, label4].forEach{ $0?.textAlignment = .center }
        
        view.addSubview(label1)
        view.addSubview(label2)
        view.addSubview(label3)
        view.addSubview(label4)
        
        let viewModel1 = LabelViewModel(milliseconds: 0)
        viewModel1.textElement.delegate = self
        label1.bind(to: viewModel1)
        
        let viewModel2 = LabelViewModel(milliseconds: 300)
        label2.bind(to: viewModel2)
        
        let viewModel3 = LabelViewModel(milliseconds: 600)
        label3.bind(to: viewModel3)
        
        let viewModel4 = LabelViewModel(milliseconds: 900)
        label4.bind(to: viewModel4)
        
        labelViewModels = [viewModel1, viewModel2, viewModel3, viewModel4]
    }
    
    func shouldUpdateView(_ ObserveElement: Any) -> Bool {
        if let element = ObserveElement as? ObserveElement<String> {
            print("WILL:\(element.value ?? "nil")")
            if element.value == "GOGOGO" {
                return false
            }
        }
        return true
    }
    
    func didUpdateView(_ ObserveElement: Any) {
        if let element = ObserveElement as? ObserveElement<String> {
            print("DID:\(element.value ?? "nil")")
        }
    }

    @IBAction func buttonClick(_ sender: UIButton) {
        for (index, viewModel) in labelViewModels.enumerated() {
            viewModel.timer?.invalidate()
            viewModel.timer = nil
            viewModel.colorElement.value = [#colorLiteral(red: 1, green: 0.4932718873, blue: 0.4739984274, alpha: 1), #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1), #colorLiteral(red: 0.4620226622, green: 0.8382837176, blue: 1, alpha: 1), #colorLiteral(red: 0.9995340705, green: 0.988355577, blue: 0.4726552367, alpha: 1)][index]
        }
        labelViewModels.shuffle()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destinationVC = segue.destination as? TableViewController else {
            return
        }
        destinationVC.animalModels = [AnimalModel(name: "Hello World~!", imageName: "Giant Panda"),
                                      AnimalModel(name: "Hello World~~!", imageName: "Giant Panda"),
                                      AnimalModel(name: "Hello World~~~!", imageName: "Giant Panda"),
                                      AnimalModel(name: "Hello World~~~~!", imageName: "Giant Panda"),
                                      AnimalModel(name: "Hello World~~~~~!", imageName: "Giant Panda")]
    }
}

extension UILabel: Bindable {
    var viewModel: LabelViewModel? {
        return nil
    }
    
    func bind(to viewModel: LabelViewModel) {
        viewModel.textElement.setUpdate({ (value) in
            self.text = value
        })
        viewModel.colorElement.setUpdate { (value) in
            UIView.animate(withDuration: 0.5, animations: {
                self.layer.backgroundColor = value?.cgColor
                self.textColor = value
            })
        }
    }
}


