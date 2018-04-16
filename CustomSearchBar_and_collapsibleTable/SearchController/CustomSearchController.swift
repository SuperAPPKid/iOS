//
//  CustomSearchController.swift
//  SearchController
//
//  Created by zhong on 2018/4/8.
//  Copyright © 2018年 zhong. All rights reserved.
//

import UIKit

class CustomSearchController: UISearchController {
    var mySearchBar = CustomSearchBar()
    override public var searchBar: UISearchBar {
        get {
            return mySearchBar
        }
    }
    
    convenience init(searchResultsController: UIViewController?, searchBarFrame: CGRect, searchBarFont: UIFont, searchBarTextColor: UIColor, searchBarTintColor: UIColor) {
        self.init(searchResultsController: searchResultsController)
        mySearchBar = CustomSearchBar(frame: searchBarFrame, font: searchBarFont, textColor: searchBarTextColor)
        mySearchBar.barTintColor = searchBarTintColor
        mySearchBar.tintColor = searchBarTextColor
    }
    
}
