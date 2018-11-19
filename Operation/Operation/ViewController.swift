//
//  ViewController.swift
//  Operation
//
//  Created by Hank_Zhong on 2018/11/19.
//  Copyright © 2018 Hank_Zhong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var operationQueue: OperationQueue = OperationQueue()
    let operations: [TestOperation] = [TestOperation(1),
                                       TestOperation(2),
                                       TestOperation(3),
                                       TestOperation(4),
                                       TestOperation(5),
                                       TestOperation(6),
                                       TestOperation(7),
                                       TestOperation(8)]

    override func viewDidLoad() {
        super.viewDidLoad()
        operationQueue.maxConcurrentOperationCount = 8
        operationQueue.addOperations(operations, waitUntilFinished: false)
    }

    @IBAction func click(_ sender: UIButton) {
//        operationQueue.cancelAllOperations()
//        operationQueue.isSuspended.toggle()
        print(operationQueue.operationCount)
    }
    
}

class TestOperation: Operation {
    var num: Int
    var finish: Bool = false
    
    override var isFinished: Bool {
        return finish
    }
    
    init(_ num: Int) {
        self.num = num
        super.init()
        self.completionBlock = { [weak self] in
            print("Operation \(self!.num) Complete; Thread: \(Thread.current)")
        }
    }
    
    ///for async execute
//    override func start() {
//        print("Operation \(num) Start; Thread: \(Thread.current)")
//        if !self.isCancelled {
//            DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(15-num)) {
//                self.finishOperation()
//            }
//        } else {
//            self.finishOperation()
//        }
//    }
    override func start() {
        super.start()
    }
    
    ///for sync execute
    override func main() {
        super.main()
        print("Operation \(num) Start; Thread: \(Thread.current)")
        DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(9-num)) { [weak self] in
            self!.finishOperation()
        }
    }
    
    func finishOperation() {
        self.willChangeValue(for: \.isFinished)
        self.finish = true
        self.didChangeValue(for: \.isFinished)
    }
}
