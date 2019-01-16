//
//  APIServiceTask.swift
//  NetWorkLayer
//
//  Created by Hank_Zhong on 2019/1/14.
//  Copyright © 2019 Hank_Zhong. All rights reserved.
//

import Foundation

//https://developer.apple.com/documentation/foundation/operation
class AsyncOperation: Operation {
    override var isAsynchronous: Bool {
        return true
    }
    
    private var _isReady: Bool
    override var isReady: Bool {
        get {
            return _isReady
        }
        set {
            menualKVO(for: "isReady") {
                self._isReady = newValue
            }
        }
    }
    
    private var _isExecuting: Bool
    override var isExecuting: Bool {
        get {
            return _isExecuting
        }
        set {
            menualKVO(for: "isExecuting") {
                self._isExecuting = newValue
            }
        }
    }
    
    private var _isFinished: Bool
    override var isFinished: Bool {
        get {
            return _isFinished
        }
        set {
            menualKVO(for: "isFinished") {
                self._isFinished = newValue
            }
        }
    }
    
    private var _isCancelled: Bool
    override var isCancelled: Bool {
        get {
            return _isCancelled
        }
        set {
            menualKVO(for: "isCancelled") {
                self._isCancelled = newValue
            }
        }
    }
    
    private func menualKVO(for key: String, update: () -> Void) {
        willChangeValue(forKey: key)
        update()
        didChangeValue(forKey: key)
    }
    
    override init() {
        _isReady = true
        _isExecuting = false
        _isFinished = false
        _isCancelled = false
        super.init()
        name = "Async Operation"
    }
    
    override func start() {
        guard !isExecuting && !isCancelled else { return }
        _isReady = false
        _isExecuting = true
        _isFinished = false
    }
    
    override func cancel() {
        isExecuting = false
        isCancelled = true
    }
    
    fileprivate func finish() {
        isExecuting = false
        isFinished = true
    }
    
    func resume() {
        guard !isExecuting && isCancelled else { return }
        _isReady = false
        _isExecuting = true
        _isFinished = false
        _isCancelled = false
    }
    
    func pause() {
        guard isExecuting && isCancelled else { return }
        _isReady = false
        _isExecuting = false
        _isFinished = false
        _isCancelled = true
    }
}

protocol APITask {
    var queue: OperationQueue { get }
    var request: APIRequest { get }
    var error: APICoreError? { get }
}

///Use subclass of it instead of using directly.
class APIGenericTask<DataType>: AsyncOperation, APITask {
    
    var request: APIRequest
    
    fileprivate var retryTimes: UInt = 0
    fileprivate(set) var error: APICoreError? = nil
    fileprivate var callback:((APIResponseState<DataType>) -> Void)
    
    var queue: OperationQueue {
        return APIQueue.shared
    }
    
    init(request: APIRequest) {
        self.callback = { state in
            fatalError("no callback assigned")
        }
        self.request = request
        super.init()
        self.qualityOfService = .utility
    }
    
    @discardableResult
    func then(_ callback: @escaping ((APIResponseState<DataType>) -> Void)) -> APIGenericTask {
        self.callback = callback
        
        for op in queue.operations {
            guard let apiTaskInQueue = op as? APITask else { continue }
            
            if apiTaskInQueue.error == nil {
                guard request != apiTaskInQueue.request else {
                    let errorTask = APIErrorTask<DataType>(request: request, error: APICoreError.DuplicatedRequest(message: "Dublicated request"))
                    errorTask.callback = self.callback
                    queue.addOperation(errorTask)
                    finish()
                    return errorTask
                }
            }
        }
        
        queue.addOperation(self)
        return self
    }
    
    func with(priority: Float) -> APIGenericTask {
        guard let queuePriority = QueuePriority(priority: priority) else { return self }
        self.queuePriority = queuePriority
        return self
    }
    
    func retry(times: UInt) -> APIGenericTask {
        retryTimes = times
        return self
    }
    
    func executeCallback(state: APIResponseState<DataType>) {
        if case let APIResponseState.Failure(error: e) = state, retryTimes > 0 {
            let errorTask = APIErrorTask<DataType>(request: request, error: .RetryOperation(message: e.message))
            errorTask.callback = self.callback
            queue.addOperation(errorTask)
            start()
            retryTimes -= 1
        } else {
            callback(state)
            finish()
            return
        }
    }
    
    override func cancel() {
        super.cancel()
        retryTimes = 0
    }
    
}

class APIDataTask: APIGenericTask<Data> {
    
    var lazyTask: (() -> URLSessionTask)?
    private weak var task: URLSessionTask?
    private var priority: Float = 0.0
    
    override func with(priority: Float) -> Self {
        _ = super.with(priority: priority)
        self.priority = priority
        return self
    }
    
    override func start() {
        print("Start: \(queuePriority.debug) \(priority)")
        super.start()
        
        if isCancelled {
            callback(.Failure(error: APICoreError.OperationIsCancelled(message: "Operation is cancelled")))
            finish()
            return
        }
        
        guard let lazyTask = lazyTask else {
            callback(.Failure(error: APICoreError.CannotStartTask(message: "Can't start an URLSessionTask")))
            finish()
            return
        }
        
        guard task == nil || retryTimes > 0 else { return }
        let lTask = lazyTask()
        lTask.priority = priority
        task = lTask
        lTask.resume()
    }
    
    override func cancel() {
        super.cancel()
        error = APICoreError.OperationIsCancelled(message: "Operation is cancelled")
        task?.cancel()
    }
    
    override func resume() {
        super.resume()
        task?.resume()
    }
    
    override func pause() {
        super.pause()
        task?.suspend()
    }
}

class APIDecodableTask<D:Decodable>: APIGenericTask<D> {
    
    var lazyTask: (() -> URLSessionTask)?
    private weak var task: URLSessionTask?
    private var priority: Float = 0.0
    
    override func with(priority: Float) -> Self {
        _ = super.with(priority: priority)
        task?.priority = priority
        return self
    }
    
    override func start() {
        print("Start: \(queuePriority.debug) \(priority)")
        super.start()
        
        if isCancelled {
            callback(.Failure(error: APICoreError.OperationIsCancelled(message: "Operation is cancelled")))
            finish()
            return
        }
        
        guard let lazyTask = lazyTask else {
            callback(.Failure(error: APICoreError.CannotStartTask(message: "Can't start an URLSessionTask")))
            finish()
            return
        }
        
        guard task == nil || retryTimes > 0 else { return }
        let lTask = lazyTask()
        lTask.priority = priority
        task = lTask
        lTask.resume()
    }
    
    override func cancel() {
        super.cancel()
        error = APICoreError.OperationIsCancelled(message: "Operation is cancelled")
        task?.cancel()
    }
    
    override func resume() {
        super.resume()
        task?.resume()
    }
    
    override func pause() {
        super.pause()
        task?.suspend()
    }
}

class APIErrorTask<D>: APIGenericTask<D> {
    init(request: APIRequest, error: APICoreError? = nil) {
        super.init(request: request)
        self.error = error
    }
    
    override func start() {
        super.start()
        callback(APIResponseState.Failure(error: error ?? APICoreError.Unhandled(message: "Unhandled Error Occured")))
        finish()
    }
}

extension Operation.QueuePriority {
    var debug: String {
        switch self {
        case .veryLow:
            return "veryLow"
        case .low:
            return "low"
        case .normal:
            return "normal"
        case .high:
            return "high"
        case .veryHigh:
            return "veryHigh"
        }
    }
    init?(priority: Float) {
        switch priority {
        case 0.0...0.2:
            self = .veryLow
        case 0.2...0.4:
            self = .low
        case 0.4...0.6:
            self = .normal
        case 0.6...0.8:
            self = .high
        case 0.8...1.0:
            self = .veryHigh
        default:
            return nil
        }
    }
}
