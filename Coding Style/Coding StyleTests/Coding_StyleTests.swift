//
//  Coding_StyleTests.swift
//  Coding StyleTests
//
//  Created by Hank_Zhong on 2018/8/20.
//  Copyright © 2018年 Hank_Zhong. All rights reserved.
//

import XCTest
@testable import Coding_Style
class Coding_StyleTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testTableVC_viewModels() {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let rootVC = storyboard.instantiateViewController(withIdentifier: "NavigationController") as? UINavigationController
        let tableVC = rootVC?.viewControllers[0] as! TableViewController
        let cellViewModels = tableVC.cellViewModels
        let detailViewModels = tableVC.detailViewModels
        for (i,cellViewModel) in cellViewModels.enumerated() {
            XCTAssertEqual(cellViewModel.isSelect, detailViewModels[i].isGreen)
            XCTAssertEqual(cellViewModel.title, detailViewModels[i].title)
            XCTAssertEqual(cellViewModel.imageName, detailViewModels[i].imageName)
        }
    }
    
    func testAPI() {
        let expectation1 = XCTestExpectation(description: "Parse Json file - Animals")
        let expectation2 = XCTestExpectation(description: "Parse Json file - Animal")
        APIService.shared.fetchItems(APIName: "Animals", completion: { (items, error) -> (Void) in
            XCTAssertNotEqual(items.count, 0)
            expectation1.fulfill()
        })
        
        APIService.shared.fetchItems(APIName: "Animal", completion: { (items, error) -> (Void) in
            XCTAssertNotNil(error)
            expectation2.fulfill()
        })
        
        wait(for: [expectation1,expectation2], timeout: 3)
    }
    
    func testPerformanceAPI() {
        self.measure {
            let expectation = XCTestExpectation(description: "Parse Json file - Animals")
            APIService.shared.fetchItems(APIName: "Animals", completion: { (items, error) -> (Void) in
                XCTAssertNotEqual(items.count, 0)
                expectation.fulfill()
            })
            wait(for: [expectation], timeout: 3)
        }
    }
    
}
