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
    let bag = DisposeBag()
    let name = "Hello World"
    var disposer: MyDispose?
    var observable: MyObservable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let segment = UISegmentedControl(items: ["Observable", "Subject"])
        segment.addTarget(self, action: #selector(toggleSeg(_:)), for: .valueChanged)
        navigationItem.titleView = segment
        
        let subSegment = UISegmentedControl(items: ["組合", "變換", "約束", "其他"])
        subSegment.addTarget(self, action: #selector(toggleSubSeg(_:)), for: .valueChanged)
        subSegment.frame.size.width = 300
        subSegment.center.x = view.center.x
        subSegment.frame.origin.y = 150
        view.addSubview(subSegment)
        
        subSegment.rx
        .selectedSegmentIndex
        .subscribe{ print($0) }
        .disposed(by: bag)
        
        do {
            observable = MyObservable { [weak weakVC = self] (observer) -> (MyDispose) in
                guard let vc = weakVC else { return MyDispose(disposer: nil) }
                let target = MyTarget(vc: vc, callBack: { (vc) in
                    print(vc.name)
                })
                return MyDispose(disposer: target.dispose)
            }
            let observer = MyObserver()
            disposer = observable?.handler?(observer)
        }
    }
    
    @objc func toggleSeg(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            showRxObservableResult()
            break
        case 1:
            showRxSubjectResult()
            break
        default:
            break
        }
    }
    
    @objc func toggleSubSeg(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            showAssociateResult()
            break
        case 1:
            showTransformResult()
            break
        case 2:
            showFilterResult()
            break
        case 3:
            disposer = nil
            break
        default:
            break
        }
    }
    
    func showFilterResult() {
    }
    
    func showTransformResult() {
        
        print("🏆🏆🏆 Map")
        Observable.of(1,2,3).map{ $0 * 10 }.subscribe{ print($0) }.disposed(by: bag)
        
        print("🏆🏆🏆 FlapMap")
        do {
            let relay = PublishRelay<Int>()
            let preRelays = [PublishRelay<String>(), PublishRelay<String>(), PublishRelay<String>()]
            relay.flatMap { preRelays[$0] }.subscribe{ print($0) }.disposed(by: bag)
            relay.subscribe{ print($0) }.disposed(by: bag)
            relay.accept(0)
            preRelays[0].accept("🍀")
            preRelays[1].accept("🍁")
            preRelays[2].accept("🌸")
            relay.accept(1)
            preRelays[0].accept("🍀")
            preRelays[1].accept("🍁")
            preRelays[2].accept("🌸")
            relay.accept(2)
            preRelays[0].accept("🍀")
            preRelays[1].accept("🍁")
            preRelays[2].accept("🌸")
        }
        
        print("🏆🏆🏆 FlatMapLatest")
        do {
            let relay = PublishRelay<Int>()
            let preRelays = [PublishRelay<String>(), PublishRelay<String>(), PublishRelay<String>()]
            relay.flatMapLatest { preRelays[$0] }.subscribe{ print($0) }.disposed(by: bag)
            relay.subscribe{ print($0) }.disposed(by: bag)
            relay.accept(0)
            preRelays[0].accept("🍀")
            preRelays[1].accept("🍁")
            preRelays[2].accept("🌸")
            relay.accept(1)
            preRelays[0].accept("🍀")
            preRelays[1].accept("🍁")
            preRelays[2].accept("🌸")
            relay.accept(2)
            preRelays[0].accept("🍀")
            preRelays[1].accept("🍁")
            preRelays[2].accept("🌸")
        }
        
        print("🏆🏆🏆 Scan")
        Observable.of(1,2,3).scan("GO", accumulator: { $0 + " \($1)"}).subscribe{ print($0) }.disposed(by: bag)
    }
    
    func showAssociateResult() {
        print("🏆🏆🏆 StartWith")
        Observable.of("2","3").startWith("1").subscribe{ print($0) }.disposed(by: bag)
        
        print("🏆🏆🏆 Merge")
        do {
            let relay1 = BehaviorRelay(value: "♠️")
            let relay2 = BehaviorRelay(value: "♥️")
            Observable.of(relay1, relay2).merge().subscribe{ print($0) }.disposed(by: bag)
            relay1.accept("1")
            relay1.accept("2")
            relay2.accept("A")
            relay1.accept("3")
            relay2.accept("B")
            relay2.accept("C")
        }
        
        print("🏆🏆🏆 Zip")
        do {
            let relayInt = PublishRelay<Int>()
            let relayStr = PublishRelay<String>()
            Observable.zip(relayInt, relayStr) { (int, str) in
                return "\(int): \(str)"
                }.subscribe{ print($0) }.disposed(by: bag)
            relayInt.accept(1)
            relayStr.accept("👊")
            relayInt.accept(2)
            relayInt.accept(3)
            relayStr.accept("👊🏿")
            relayStr.accept("👊🏼")
            relayInt.accept(4)
        }
        
        print("🏆🏆🏆 CombineLatest")
        do {
            let relayInt = PublishRelay<Int>()
            let relayStr = PublishRelay<String>()
            Observable.combineLatest(relayInt, relayStr) { (int, str) in
                return "\(int): \(str)"
                }.subscribe{ print($0) }.disposed(by: bag)
            relayInt.accept(1)
            relayStr.accept("👊")
            relayInt.accept(2)
            relayInt.accept(3)
            relayStr.accept("👊🏿")
            relayStr.accept("👊🏼")
            relayInt.accept(4)
        }
        
        print("🏆🏆🏆 SwitchLatest")
        do {
            let relay = PublishRelay<PublishRelay<String>>()
            let relay1 = PublishRelay<String>()
            let relay2 = PublishRelay<String>()
            relay.switchLatest().subscribe{ print($0) }.disposed(by: bag)
            relay.accept(relay1)
            relay1.accept("💀")
            relay2.accept("☠️")
            relay.accept(relay2)
            relay1.accept("🤡")
            relay2.accept("😈")
        }
    }
    
    func showRxSubjectResult() {
        let disposeBag = DisposeBag()
        let publishSub = PublishSubject<String>()
        let replaySub = ReplaySubject<String>.create(bufferSize: 5)
        let behaviorSub = BehaviorSubject(value: "⚽️")
        let variable = Variable("🔔")
        let bRelay = BehaviorRelay(value: "🌶")
        let pRelay = PublishRelay<String>()
        
        print("🏆🏆🏆 PublishSubject")
        print("🏆🏆 Add P1")
        publishSub.subscribe{print("observer P1: \($0)")}.disposed(by: disposeBag)
        publishSub.onNext("🎈")
        publishSub.onNext("🔰")
        print("🏆🏆 Add P2")
        publishSub.subscribe{print("observer P2: \($0)")}.disposed(by: disposeBag)
        publishSub.onNext("0️⃣")
        publishSub.onNext("🔟")
        
        print("🏆🏆🏆 ReplaySubject")
        replaySub.onNext("⚪️")
        print("🏆🏆 Add R1")
        replaySub.subscribe{print("observer R1: \($0)")}.disposed(by: disposeBag)
        replaySub.onNext("⚫️")
        replaySub.onNext("🔴")
        print("🏆🏆 Add R2")
        replaySub.subscribe{print("observer R2: \($0)")}.disposed(by: disposeBag)
        replaySub.onNext("🔵")
        
        print("🏆🏆🏆 BehaviorSubject")
        behaviorSub.onNext("⚪️")
        print("🏆🏆 Add B1")
        behaviorSub.subscribe{print("observer B1: \($0)")}.disposed(by: disposeBag)
        behaviorSub.onNext("⚫️")
        behaviorSub.onNext("🔴")
        print("🏆🏆 Add B2")
        behaviorSub.subscribe{print("observer B2: \($0)")}.disposed(by: disposeBag)
        behaviorSub.onNext("🔵")
        
        print("🏆🏆🏆 Variable")
        print("🏆🏆 Add V1")
        variable.asObservable().subscribe{print("observer V1: \($0)")}.disposed(by: disposeBag)
        variable.value = "🔕"
        print("🏆🏆 Add V2")
        variable.asObservable().subscribe{print("observer V2: \($0)")}.disposed(by: disposeBag)
        variable.value = "📣"
        
        print("🏆🏆🏆 Publish Relay")
        print("🏆🏆 Add Prelay1")
        pRelay.accept("🥝")
        pRelay.subscribe{print("observer Prelay1: \($0)")}.disposed(by: disposeBag)
        pRelay.accept("🍌")
        print("🏆🏆 Add Prelay2")
        pRelay.subscribe{print("observer Prelay2: \($0)")}.disposed(by: disposeBag)
        pRelay.accept("🍒")
        
        print("🏆🏆🏆 Behavior Relay1")
        print("🏆🏆 Add Brelay1")
        bRelay.subscribe{print("observer Brelay1: \($0)")}.disposed(by: disposeBag)
        bRelay.accept("🍊")
        print("🏆🏆 Add Brelay1")
        bRelay.subscribe{print("observer Brelay2: \($0)")}.disposed(by: disposeBag)
        bRelay.accept("🍉")
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
        
        print("🏆🏆🏆 Of")
        Observable.of("🐶", "🐱", "🐭", "🐹")
            .subscribe(onNext: { element in
                print(element)
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

//以下相關技術
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

class MyObserver {}
class MyDispose {
    typealias Disposer = () -> Void
    var disposer: Disposer?
    init(disposer: Disposer?) {
        self.disposer = disposer
    }
    
    deinit {
        print("MyDispose Dead")
    }
}
class MyObservable {
    typealias Handler = (MyObserver) -> (MyDispose)
    var handler: Handler?
    init(_ handler: Handler?) {
        self.handler = handler
    }
    
    deinit {
        print("MyObservable Dead")
    }
}
class MyTarget {
    typealias CallBack = (ViewController) -> Void
    weak var vc: ViewController?
    var callBack: CallBack?
    
//    lazy var dispose: (() -> (Void)) = { [weak self] in
//        guard let self = self else { return }
//        self.callBack = nil
//        self.vc = nil
//    }
    
        func dispose() {
            callBack = nil
            vc = nil
        }
    
    init(vc: ViewController, callBack: @escaping CallBack) {
        self.vc = vc
        self.callBack = callBack
    }
    
    
    deinit {
        print("MyTarget Dead")
    }
}
