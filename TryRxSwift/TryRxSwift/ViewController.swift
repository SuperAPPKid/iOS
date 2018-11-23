//
//  ViewController.swift
//  TryRxSwift
//
//  Created by Hank_Zhong on 2018/11/22.
//  Copyright © 2018 Hank_Zhong. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let segment = UISegmentedControl(items: ["Observable", "placeholder", "placeholder"])
        segment.addTarget(self, action: #selector(toggleSeg(_:)), for: .valueChanged)
        navigationItem.titleView = segment
    }
    
    @objc func toggleSeg(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            showRxObservableResult()
            break
        default:
            break
        }
    }
    
    
    func showRxObservableResult() {
        print("🏆🏆🏆 Never")
        Observable<String>.never().subscribe({ (event) in
            print(event)
        }).dispose()
        
        print("🏆🏆🏆 Empty")
        Observable<String>.empty().subscribe({ (event) in
            print(event)
        }).dispose()
        
        print("🏆🏆🏆 Just")
        Observable.just("🍙").subscribe({ (event) in
            print(event)
        }).dispose()
        
        print("🏆🏆🏆 From")
        Observable.from(["🥇","🥈","🥉",1,2,3]).subscribe({ (event) in
            print(event)
        }).dispose()
        
        print("🏆🏆🏆 Create")
        Observable.create { (observer: AnyObserver<String>) -> Disposable in
            observer.onNext("Hello")
            observer.on(Event.next("World"))
            observer.onCompleted()
            return Disposables.create()
            }.subscribe { print($0) }.dispose()
        
        print("🏆🏆🏆 Range")
        Observable.range(start: 1, count: 5).subscribe({ (event) in
            print(event)
        }).dispose()
        
        print("🏆🏆🏆 Repeat")
        Observable.repeatElement("🦄").take(3).subscribe({ (event) in
            print(event)
        }).dispose()
        
        print("🏆🏆🏆 Generate")
        Observable.generate(initialState: 0, condition: { $0 < 3 }, iterate: { $0 + 1 }).subscribe({ (event) in
            print(event)
        }).dispose()
        
        print("🏆🏆🏆 Defered")
        let deferredSequence = Observable<String>.deferred { () -> Observable<String> in
            print("creating new observable")
            return Observable.from(["🙉","🙊","🙈"])
        }
        
        deferredSequence.subscribe({ (event) in
            print(event)
        }).dispose()
        
        deferredSequence.subscribe({ (event) in
            print(event)
        }).dispose()
        
        print("🏆🏆🏆 Error")
        Observable<String>.error(NSError(domain: "TestError", code: 999, userInfo: nil)).subscribe({ (event) in
            print(event)
        }).dispose()
        
        print("🏆🏆🏆 DoOn")
        Observable.from(["🙉","🙊","🙈"])
            .do(onNext: { print("Will: \($0)") },
                onCompleted: { print("Will Complete") },
                onSubscribe: { print("Will Subscribe") },
                onSubscribed: { print("Did Subscribe") },
                onDispose: { print("Will Dispose") })
            .subscribe{ print($0) }
            .dispose()
        
    }
}


struct Magic<Base> {
    let base: Base
}
extension Magic where Base: UITextView {
    var num: Int {
        return 100
    }
}
protocol Testable {
    associatedtype T
    var hz: Magic<Self.T> { get }
}
extension Testable {
    var hz: Magic<Self> {
        return Magic(base: self)
    }
}
extension NSObject: Testable{}
