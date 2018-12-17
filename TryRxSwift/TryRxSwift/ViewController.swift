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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let segment = UISegmentedControl(items: ["Observable", "Subject"])
        segment.addTarget(self, action: #selector(toggleSeg(_:)), for: .valueChanged)
        navigationItem.titleView = segment
        
        let subSegment = UISegmentedControl(items: ["組合", "變換", "約束", "連接", "其他"])
        subSegment.addTarget(self, action: #selector(toggleSubSeg(_:)), for: .valueChanged)
        subSegment.frame.size.width = 300
        subSegment.center.x = view.center.x
        subSegment.frame.origin.y = 150
        view.addSubview(subSegment)
        
        let subSubSegment = UISegmentedControl(items: ["ObserveOn", "SubscribeOn", "ShareReplay"])
        subSubSegment.addTarget(self, action: #selector(toggleSubSubSeg(_:)), for: .valueChanged)
        subSubSegment.frame.size.width = 300
        subSubSegment.center.x = view.center.x
        subSubSegment.frame.origin.y = 300
        view.addSubview(subSubSegment)
        
        subSegment.rx
        .selectedSegmentIndex
        .subscribe{ print() }
        .disposed(by: bag)
        
        UIButton().rx.tap.subscribe().disposed(by: bag)
        
        do {
            let myObservable = MyObservable { [weak weakVC = self] (observer) -> (MyDispose) in
                guard let vc = weakVC else { return MyDispose(disposer: nil) }
                let target = MyTarget(vc: vc, callBack: { (vc) in
                    print(vc.name)
                })
                return MyDispose(disposer: target.dispose)
            }
            let observer = MyObserver()
            disposer = myObservable.handler?(observer)
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
            showConnect()
            break
        case 4:
            disposer = nil
            showOthers()
            break
        default:
            break
        }
    }
    
    @objc func toggleSubSubSeg(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            print("🏆🏆🏆 ObserveOn")
            Observable.of("🤪","😱","🤑","🤐").observeOn(MainScheduler.instance).subscribe{ print("Thread\(Thread.current): \($0)") }.disposed(by: bag)
            Observable.of(1,2,3,4).observeOn(ConcurrentMainScheduler.instance).subscribe{ print("Thread\(Thread.current): \($0)") }.disposed(by: bag)
            Observable.of("😤","🤯","🤮","😪").observeOn(SerialDispatchQueueScheduler(qos: .default)).subscribe{ print("Thread\(Thread.current): \($0)") }.disposed(by: bag)
            Observable.of(5,6,7,8).observeOn(ConcurrentDispatchQueueScheduler(qos: .default)).subscribe{ print("Thread\(Thread.current): \($0)") }.disposed(by: bag)
            break
        case 1:
            print("🏆🏆🏆 SubscribeOn")
            Observable.of(1,2,3,4,5)
                .observeOn(MainScheduler.instance)
                .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .default))
                .subscribe{ print("Thread\(Thread.current): \($0)") }.disposed(by: bag)
            Observable.of(6,7,8,9)
                .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .default))
                .subscribe{ print("Thread\(Thread.current): \($0)") }.disposed(by: bag)
            Observable.of(6,7,8,9)
                .subscribe{ print("Thread\(Thread.current): \($0)") }.disposed(by: bag)
            break
        case 2:
            print("🏆🏆🏆 ShareReplay (NoShare)")
            let pSubjectN = PublishSubject<String>()
            let pObservaleShareN = pSubjectN.map({ (str) -> String in
                print("Do Map")
                return str
            })
            pObservaleShareN.subscribe{ print("Subscribe 1: \($0)") }.disposed(by: bag)
            pObservaleShareN.subscribe{ print("Subscribe 2: \($0)") }.disposed(by: bag)
            pObservaleShareN.subscribe{ print("Subscribe 3: \($0)") }.disposed(by: bag)
            pSubjectN.onNext("💋")
            pSubjectN.onNext("💄")
            
            print("🏆🏆🏆 Share")
            let pSubject = PublishSubject<String>()
            let pObservaleShare = pSubject.map({ (str) -> String in
                print("Do Map")
                return str
            }).share()
            pObservaleShare.subscribe{ print("Subscribe 1: \($0)") }.disposed(by: bag)
            pObservaleShare.subscribe{ print("Subscribe 2: \($0)") }.disposed(by: bag)
            pObservaleShare.subscribe{ print("Subscribe 3: \($0)") }.disposed(by: bag)
            pSubject.onNext("👘")
            pSubject.onNext("👙")
            
            print("🏆🏆🏆 ShareReplay (Forever)")
            let pSubjectF = PublishSubject<String>()
            let pObservaleShareF = pSubjectF.map({ (str) -> String in
                print("Do Map")
                return str
            }).share(replay: 1, scope: .forever)
            pObservaleShareF.subscribe{ print("Subscribe 1: \($0)") }.disposed(by: bag)
            pObservaleShareF.subscribe{ print("Subscribe 2: \($0)") }.disposed(by: bag)
            pObservaleShareF.subscribe{ print("Subscribe 3: \($0)") }.disposed(by: bag)
            pSubjectF.onNext("👹")
            pSubjectF.onNext("👾")
            
            print("🏆🏆🏆 ShareReplay (Connected)")
            let pSubjectC = PublishSubject<String>()
            let pObservaleShareC = pSubjectC.map({ (str) -> String in
                print("Do Map")
                return str
            }).share(replay: 1, scope: .whileConnected)
            pObservaleShareC.subscribe{ print("Subscribe 1: \($0)") }.disposed(by: bag)
            pObservaleShareC.subscribe{ print("Subscribe 2: \($0)") }.disposed(by: bag)
            pObservaleShareC.subscribe{ print("Subscribe 3: \($0)") }.disposed(by: bag)
            pSubjectC.onNext("✌🏻")
            pSubjectC.onNext("🤞🏻")
            break
        default:
            break
        }
    }
    
    func showConnect() {
        print("🏆🏆🏆 Publish")
        do {
            let connection = Observable.from(Array("❤️🧡💛")).publish()
            connection.subscribe{ print("Subscribe 1: \($0)") }.disposed(by: bag)
            connection.subscribe{ print("Subscribe 2: \($0)") }.disposed(by: bag)
            connection.subscribe{ print("Subscribe 3: \($0)") }.disposed(by: bag)
            print("Did Subscribe")
            print("Will Connect")
            connection.connect().disposed(by: bag)
            print("After Connect")
        }
        
        print("🏆🏆🏆 Replay")
        do {
            let publishRelay = PublishRelay<Int>()
            let connection = publishRelay.replay(2)
            connection.subscribe{ print("Subscribe 1: \($0)") }.disposed(by: bag)
            publishRelay.accept(1)
            publishRelay.accept(2)
            connection.connect().disposed(by: bag)
            publishRelay.accept(3)
            publishRelay.accept(4)
            publishRelay.accept(5)
            publishRelay.accept(6)
            connection.subscribe{ print("Subscribe 2: \($0)") }.disposed(by: bag)
            publishRelay.accept(7)
            publishRelay.accept(8)
        }
        
        print("🏆🏆🏆 Multicast")
        do {
            let behaviorSubject = BehaviorSubject(value: "💔")
            let publishRelay = PublishRelay<String>()
            let connection = publishRelay.multicast(behaviorSubject)
            connection.subscribe{ print("Subscribe 1: \($0)") }.disposed(by: bag)
            publishRelay.accept("❤️")
            publishRelay.accept("🧡")
            connection.connect().disposed(by: bag)
            publishRelay.accept("💛")
            publishRelay.accept("💚")
            publishRelay.accept("💙")
            connection.subscribe{ print("Subscribe 2: \($0)") }.disposed(by: bag)
            publishRelay.accept("💜")
            publishRelay.accept("🖤")
        }
    }
    
    func showOthers() {
        print("🏆🏆🏆 ToArray")
        Observable.of("🐖","🐏","🦒","🐓","🐈").toArray().subscribe{ print($0) }.disposed(by: bag)
        
        print("🏆🏆🏆 Reduce")
        Observable.of(10, 100, 1000).reduce(8, accumulator: +).subscribe{ print($0) }.disposed(by: bag)
        
        print("🏆🏆🏆 Concat")
        do {
            let sourceSub = PublishSubject<String>()
            let concatSub = PublishSubject<String>()
            Observable.of(sourceSub, concatSub).concat().subscribe{ print($0) }.disposed(by: bag)
            concatSub.onNext("🔮")
            sourceSub.onNext("🚗")
            sourceSub.onNext("🚕")
            sourceSub.onCompleted()
            sourceSub.onNext("🚙")
            concatSub.onNext("💰")
            concatSub.onNext("💎")
        }
        
        print("🏆🏆🏆 CatchErrorJustReturn")
        do {
            let publishSub = PublishSubject<String>()
            publishSub.catchErrorJustReturn("❌").subscribe{ print($0) }.disposed(by: bag)
            publishSub.onNext("⭕️")
            publishSub.onNext("⭕️")
            publishSub.onNext("⭕️")
            publishSub.onError(RxError.unknown)
        }
        
        print("🏆🏆🏆 CatchError")
        do {
            let publishSub = PublishSubject<String>()
            let recoverSub = PublishSubject<String>()
            publishSub.catchError({ (error) -> Observable<String> in
                print("❌ : \(error.localizedDescription)")
                return recoverSub
            }).subscribe{ print($0) }.disposed(by: bag)
            recoverSub.onNext("🔆")
            publishSub.onNext("⭕️")
            recoverSub.onNext("🔆")
            publishSub.onNext("⭕️")
            recoverSub.onNext("🔆")
            publishSub.onNext("⭕️")
            publishSub.onError(RxError.unknown)
            recoverSub.onNext("🔰")
        }
        
        print("🏆🏆🏆 Retry")
        do {
            var count = 0
            let errorPossible = Observable<String>.create { (observer) -> Disposable in
                if count < 2 {
                    observer.onError(RxError.unknown)
                    print("💔")
                    count += 1
                }
                observer.onNext("❤️")
                observer.onNext("🧡")
                observer.onNext("💛")
                observer.onNext("💚")
                observer.onNext("💙")
                observer.onNext("💜")
                observer.onCompleted()
                return Disposables.create()
            }
            errorPossible.retry(5).subscribe{ print($0) }.disposed(by: bag)
        }
        
        print("🏆🏆🏆 Debug")
        Observable.of(1,2,3,4,5).debug().subscribe{ print($0) }.disposed(by: bag)
        
        print("🏆🏆🏆 Resource")
        print("Resources Used: \(Resources.total)")
    }
    
    func showFilterResult() {
        print("🏆🏆🏆 Filter")
        Observable.of("🐖","🐏","🦒","🐓","🐈","🐖","🐖").filter{ $0 == "🐖" }.subscribe{ print($0) }.disposed(by: bag)
        
        print("🏆🏆🏆 DistinctUntilChanged")
        Observable.of("🐖","🐏","🐖","🦒","🐓","🐓","🐈").distinctUntilChanged().subscribe{ print($0) }.disposed(by: bag)
        
        print("🏆🏆🏆 ElementAt")
        Observable.of("🐖","🐏","🐖","🦒","🐓","🐓","🐈").elementAt(3).subscribe{ print($0) }.disposed(by: bag)
        
        print("🏆🏆🏆 Single")
        do {
            let singleOB1 = Observable.of("🐖","🐏","🦒","🐓","🐈").single()
            let singleOB2 = Observable.of("🐖","🐖","🐏","🦒","🐓","🐈").single{ $0 == "🐖"}
            singleOB1.subscribe{ print($0) }.disposed(by: bag)
            singleOB2.subscribe{ print($0) }.disposed(by: bag)
        }
        
        print("🏆🏆🏆 Take")
        Observable.of(1,2,3,4,5,6,7,8,9).take(3).subscribe{ print($0) }.disposed(by: bag)
        
        print("🏆🏆🏆 TakeLast")
        Observable.of(1,2,3,4,5,6,7,8,9).takeLast(3).subscribe{ print($0) }.disposed(by: bag)
        
        print("🏆🏆🏆 TakeWhile")
        Observable.of(1,2,3,4,5,6,7,8,9).takeWhile{ $0 <= 5 }.subscribe{ print($0) }.disposed(by: bag)
        
        print("🏆🏆🏆 TakeUntil")
        do {
            let PRelay = PublishRelay<String>()
            PRelay.subscribe{ print($0) }.disposed(by: bag)
            let TRelay = PublishRelay<Int>()
            TRelay.takeUntil(PRelay).subscribe{ print($0) }.disposed(by: bag)
            TRelay.accept(1)
            TRelay.accept(2)
            TRelay.accept(3)
            PRelay.accept("Stop")
            TRelay.accept(4)
            TRelay.accept(5)
        }
        
        print("🏆🏆🏆 Skip")
        Observable.from(Array("ABCDEFG")).skip(3).subscribe{ print($0) }.disposed(by: bag)
        print("🏆🏆🏆 SkipWhile")
        Observable.from([1,2,3,4,5,6]).skipWhile{ $0 < 4 }.subscribe{ print($0) }.disposed(by: bag)
        print("🏆🏆🏆 SkipUntil")
        do {
            let PRelay = PublishRelay<String>()
            PRelay.subscribe{ print($0) }.disposed(by: bag)
            let TRelay = PublishRelay<Int>()
            TRelay.skipUntil(PRelay).subscribe{ print($0) }.disposed(by: bag)
            TRelay.accept(1)
            TRelay.accept(2)
            TRelay.accept(3)
            PRelay.accept("Stop")
            TRelay.accept(4)
            TRelay.accept(5)
        }
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
