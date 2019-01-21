//
//  AccountCell.swift
//  KeychainTest
//
//  Created by Hank_Zhong on 2019/1/21.
//  Copyright © 2019 Hank_Zhong. All rights reserved.
//

import UIKit

class AccountCell: UICollectionViewCell {
    static var identify: String {
        return String(describing: self)
    }
    
    var account: Account? {
        didSet {
            idLabel.text = "帳號： \(account?.ID ?? "")"
            pwdLabel.text = "密碼： \(account?.PWD ?? "")"
        }
    }
    private let stackView: UIStackView
    let idLabel: UILabel
    let pwdLabel: UILabel
    
    override init(frame: CGRect) {
        idLabel = UILabel()
        pwdLabel = UILabel()
        stackView = UIStackView(arrangedSubviews: [idLabel, pwdLabel])
        
        super.init(frame: frame)
        contentView.layer.cornerRadius = 20
        contentView.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        
        pwdLabel.font = UIFont(name: "Futura-Bold", size: 20)
        idLabel.font = UIFont(name: "Futura-Bold", size: 20)
        
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)
        let constraints = [stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
                           stackView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
                           stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                           stackView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
                           idLabel.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.8),
                           pwdLabel.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.8)]
        NSLayoutConstraint.activate(constraints)
    }
    
    required init?(coder aDecoder: NSCoder) {
        return nil
    }
    
    override func layoutSubviews() {
        print(#function)
        super.layoutSubviews()
    }
    
    override func prepareForReuse() {
        print(#function)
        super.prepareForReuse()
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        print(#function)
        super.apply(layoutAttributes)
    }
}
