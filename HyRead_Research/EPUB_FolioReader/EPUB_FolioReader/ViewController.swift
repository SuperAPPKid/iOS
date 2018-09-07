//
//  ViewController.swift
//  EPUB_FolioReader
//
//  Created by Hank_Zhong on 2018/9/5.
//  Copyright © 2018年 Hank_Zhong. All rights reserved.
//

import UIKit
import GCDWebServer

class ViewController: UIViewController {
    var webUploader: GCDWebUploader!
    var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //navigationbar
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        let serverSwitch = UISwitch()
        serverSwitch.center = CGPoint(x: 100, y: 100)
        serverSwitch.isOn = false
        serverSwitch.tintColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
        serverSwitch.onTintColor = #colorLiteral(red: 0.2818748258, green: 0.5920657151, blue: 0.7495914089, alpha: 1)
        serverSwitch.addTarget(self, action: #selector(toogleServer(sender:)), for: .valueChanged)
        navigationItem.title = "Server 關閉中"
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: serverSwitch)
        
        //create server
        let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? NSHomeDirectory() + "/Documents"
        webUploader = GCDWebUploader(uploadDirectory: documentPath)
        
        //serverURL label
        label = UILabel(frame: CGRect(x: 50, y: 75, width: 300, height: 50))
        label.text = "URL:???"
        view.addSubview(label)
        
        //detail buttons
        let epubBtn = UIButton(type: .system)
        let imgBtn = UIButton(type: .system)
        let musicBtn = UIButton(type: .system)
        let videoBtn = UIButton(type: .system)
        let stackView = UIStackView(frame: CGRect(x: 50, y: 200, width: 250, height: 300))
        let attributes = [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 25),
                          NSAttributedStringKey.foregroundColor: UIColor.black]
        epubBtn.setAttributedTitle(NSAttributedString(string: "EPUB", attributes: attributes), for: .normal)
        epubBtn.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        epubBtn.tag = 0
        epubBtn.addTarget(self, action: #selector(toList(sender:)), for: .touchUpInside)
        imgBtn.setAttributedTitle(NSAttributedString(string: "image", attributes: attributes), for: .normal)
        imgBtn.backgroundColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
        imgBtn.tag = 1
        imgBtn.addTarget(self, action: #selector(toList(sender:)), for: .touchUpInside)
        musicBtn.setAttributedTitle(NSAttributedString(string: "music", attributes: attributes), for: .normal)
        musicBtn.backgroundColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
        musicBtn.tag = 2
        musicBtn.addTarget(self, action: #selector(toList(sender:)), for: .touchUpInside)
        videoBtn.setAttributedTitle(NSAttributedString(string: "video", attributes: attributes), for: .normal)
        videoBtn.backgroundColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
        videoBtn.tag = 3
        videoBtn.addTarget(self, action: #selector(toList(sender:)), for: .touchUpInside)
        
        //stack view
        stackView.addArrangedSubview(epubBtn)
        stackView.addArrangedSubview(imgBtn)
        stackView.addArrangedSubview(musicBtn)
        stackView.addArrangedSubview(videoBtn)
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 20
        view.addSubview(stackView)
    }
    
    @objc func toogleServer(sender: UISwitch) {
        if sender.isOn {
            webUploader.start()
            navigationItem.title = "Server 開啟中"
            label?.text = "URL : \(webUploader?.serverURL?.absoluteString ?? "???")"
        } else {
            webUploader?.stop()
            navigationItem.title = "Server 關閉中"
            label?.text = "URL : ???"
        }
    }
    
    @objc func toList(sender:UIButton) {
        let listVC = ListViewController()
        guard let type = FileType(rawValue: sender.tag) else { return }
        switch type {
        case .epub:
            listVC.supportedExtensions = ["epub"]
        case .image:
            listVC.supportedExtensions = ["jpg","png"]
        case .music:
            listVC.supportedExtensions = ["mp3"]
        case .video:
            listVC.supportedExtensions = ["epub"]
        }
        listVC.selectColor = sender.backgroundColor
        listVC.title = sender.attributedTitle(for: .normal)?.string
        navigationController?.pushViewController(listVC, animated: true)
    }
}

enum FileType: Int {
    case epub
    case image
    case music
    case video
}
