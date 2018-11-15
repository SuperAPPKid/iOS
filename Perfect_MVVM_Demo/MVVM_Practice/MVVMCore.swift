//
//  MVVMCore.swift
//  MVVM_Practice
//
//  Created by Hank_Zhong on 2018/11/14.
//  Copyright © 2018 Hank_Zhong. All rights reserved.
//

import Foundation

@objc protocol ObserveElementDelegate: AnyObject {
    @objc optional func shouldUpdateView(_ ObserveElement: Any) -> Bool
    @objc optional func didUpdateView(_ ObserveElement: Any)
}

class ObserveElement<T> {
    typealias ValueUpdateCallback = ((T?) -> ())
    
    var value: T? {
        didSet {
            update(new: value, old: oldValue)
        }
    }
    var delay: UInt
    private var callBack: ValueUpdateCallback?
    weak var delegate: ObserveElementDelegate?
    
    convenience init(_ value: T? = nil) {
        self.init(value, delayMilliSeconds: 0)
    }
    
    init(_ value: T? = nil, delayMilliSeconds: UInt) {
        self.value = value
        self.delay = delayMilliSeconds
    }
    
    func setUpdate(_ callBack: @escaping ValueUpdateCallback) {
        self.callBack = callBack
        update(new: value, old: value)
    }
    
    func unBind(){
        self.callBack  = nil
    }
    
    private func execute(value: T? ,Update callBack: ValueUpdateCallback?){
        if delay == 0 {
            callBack?(value)
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(Int(delay))) {
                callBack?(value)
            }
        }
    }
    
    private func update(new: T?, old: T?) {
        if let delegate = delegate {
            if (delegate.shouldUpdateView?(self) ?? true) {
                execute(value: value, Update: callBack)
            } else {
                value = old
            }
            delegate.didUpdateView?(self)
        } else {
            execute(value: value, Update: callBack)
        }
    }
}

protocol Bindable {
    associatedtype T
    func bind(to viewModel: T)
    var viewModel: T? { get }
}
