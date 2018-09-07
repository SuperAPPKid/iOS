//
//  ListViewController.swift
//  EPUB_FolioReader
//
//  Created by Hank_Zhong on 2018/9/6.
//  Copyright © 2018年 Hank_Zhong. All rights reserved.
//

import UIKit
import FolioReaderKit

class ListViewController: UITableViewController {
    struct File {
        var name: String
        var path: URL
        var `extension`: String
    }
    
    var supportedExtensions: [String] = [] {
        didSet {
            guard let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first,
                let URLs = try? FileManager.default.contentsOfDirectory(at: documentURL, includingPropertiesForKeys: nil) else {
                    return
            }
            let filterURLs = URLs.filter{ supportedExtensions.contains($0.pathExtension) }
            files = filterURLs
                .map{ File(name: $0.deletingPathExtension().lastPathComponent, path: $0, extension: $0.pathExtension) }
                .sorted(by: { (f1, f2) -> Bool in
                    f1.name.localizedCompare(f2.name) == ComparisonResult.orderedAscending
                })
        }
    }
    var selectColor: UIColor?
    var name: String?
    
    private var files: [File] = []
    
    let folioReader = FolioReader()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //客製化用
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorInset = .init(top: 0, left: 25, bottom: 0, right: 25)
        tableView.separatorColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        tableView.rowHeight = 80
        tableView.tableFooterView = UIView()
        navigationController?.navigationBar.tintColor = selectColor
        navigationItem.titleView = {
            let label = UILabel()
            label.textAlignment = .center
            label.text = title
            label.textColor = selectColor
            label.font = UIFont(name: "Kefa-Regular", size: 36)
            return label
        }()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return files.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        if let ccc = tableView.dequeueReusableCell(withIdentifier: "cell") {
            cell = ccc
        } else {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
            let bgColorView = UIView()
            bgColorView.backgroundColor = selectColor
            cell.selectedBackgroundView = bgColorView
        }
        
        cell.textLabel?.text = files[indexPath.row].name
        cell.detailTextLabel?.text = files[indexPath.row].path.path
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let config = FolioReaderConfig(withIdentifier: "omg")
        config.scrollDirection = .horizontalWithVerticalContent
        config.canChangeScrollDirection = false
        config.enableTTS = false
        config.displayTitle = true
        config.allowSharing = false
        config.tintColor = UIColor.blue
        config.menuTextColor = UIColor.brown
        config.menuBackgroundColor = UIColor.lightGray
        config.hidePageIndicator = true
        
        let bookPath = files[indexPath.row].path.path
        folioReader.presentReader(parentViewController: self, withEpubPath: bookPath, andConfig: config)
    }
}

extension UIFont {
    func listAllFont() {
        for fontFamilyName in UIFont.familyNames{
            for fontName in UIFont.fontNames(forFamilyName: fontFamilyName){
                print("Family: \(fontFamilyName)     Font: \(fontName)")
            }
        }
    }
}
