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
    typealias ValueUpdateCallback = ((ViewModel?, T?, Bool) -> ())
    
    unowned var viewModel: ViewModel
    
    var delay: UInt
    private(set) var value: T?
    private var oldValue: T?
    private var callBack: ValueUpdateCallback?
    weak var delegate: ObserveElementDelegate?
    
    convenience init(belong viewModel: ViewModel, value: T? = nil) {
        self.init(belong: viewModel, value: value , delayMilliSeconds: 0)
    }
    
    init(belong viewModel: ViewModel, value: T? = nil, delayMilliSeconds: UInt) {
        self.viewModel = viewModel
        self.value = value
        self.delay = delayMilliSeconds
    }
    
    func setUpdate(updateNow: Bool = true, _ callBack: @escaping ValueUpdateCallback) {
        self.callBack = callBack
        if updateNow {
            update(new: value, old: value, animated: false)
        }
    }
    
    func unBind(){
        self.callBack = nil
    }
    
    func set(_ newValue: T?, animated: Bool = false) {
        oldValue = value
        value = newValue
        update(new: newValue, old: oldValue, animated: animated)
    }
    
    private func execute(value: T?, animated: Bool, update callBack: ValueUpdateCallback?){
        if delay == 0 {
            DispatchQueue.main.async {
                callBack?(self.viewModel, value, animated)
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(Int(delay))) {
                callBack?(self.viewModel , value, animated)
            }
        }
    }
    
    private func update(new: T?, old: T?, animated: Bool) {
        if let delegate = delegate {
            if (delegate.shouldUpdateView?(self) ?? true) {
                execute(value: new, animated: animated, update: callBack)
            } else {
                value = oldValue
                execute(value: old, animated: animated, update: callBack)
            }
            delegate.didUpdateView?(self)
        } else {
            execute(value: new, animated: animated, update: callBack)
        }
    }
    
    deinit {
        print("Element Dead")
    }
}

protocol Bindable {
    associatedtype T
    func bind(to viewModel: T)
    var viewModel: T? { get }
}

protocol ViewModel: AnyObject {
    func generateObserveElement<T>(value: T?, delayMilliSeconds: UInt) -> ObserveElement<T>
}

extension ViewModel {
    func generateObserveElement<T>(value: T? = nil, delayMilliSeconds: UInt = 0) -> ObserveElement<T> {
        return ObserveElement(belong: self, value: value, delayMilliSeconds: delayMilliSeconds)
    }
}
