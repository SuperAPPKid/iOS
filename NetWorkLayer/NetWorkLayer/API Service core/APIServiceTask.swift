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
        guard !isExecuting else { return }
        _isReady = false
        _isExecuting = true
        _isFinished = false
        _isCancelled = false
    }
    
    override func cancel() {
        isExecuting = false
        isCancelled = true
    }
    
    func finish() {
        isExecuting = false
        isFinished = true
    }
}

///Use subclass of it instead of using directly.
class APIGenericTask<E>: AsyncOperation {
    
    fileprivate(set) var callback:((E) -> Void)
    var queue: OperationQueue? {
        return APIQueue.shared
    }
    
    override init() {
        self.callback = { state in
            fatalError("no callback assigned")
        }
        super.init()
        self.qualityOfService = .utility
    }
    
    @discardableResult
    func then(_ callback: @escaping ((E) -> Void)) -> APIGenericTask {
        self.callback = callback
        queue?.addOperation(self)
        return self
    }
    
    func with(priority: Float) -> APIGenericTask {
        guard let queuePriority = QueuePriority(priority: priority) else { return self }
        self.queuePriority = queuePriority
        return self
    }
    
    deinit {
        print("Dead")
    }
}

class APIDataTask: APIGenericTask<APIResponseState<Data>> {
    
    weak var task: URLSessionTask?
    
    override func then(_ callback: @escaping ((APIResponseState<Data>) -> Void)) -> Self {
        self.callback = callback
        queue?.addOperation(self)
        return self
    }
    
    override func with(priority: Float) -> Self {
        guard let queuePriority = QueuePriority(priority: priority) else { return self }
        self.queuePriority = queuePriority
        task?.priority = priority
        return self
    }
    
    override func start() {
        print("Start: \(queuePriority.debug) \(task!.priority)")
        super.start()
        guard let task = task else {
            callback(.Failure(error: NSError(domain: "Can not start a urlsessionTask", code: 9999, userInfo: nil)))
            return
        }
        task.resume()
    }
    
    override func cancel() {
        task?.cancel()
        super.cancel()
    }
}

class APIDecodableTask<T:Decodable>: APIGenericTask<APIResponseState<T>> {
    
    weak var task: URLSessionTask?
    
    override func then(_ callback: @escaping ((APIResponseState<T>) -> Void)) -> Self {
        self.callback = callback
        queue?.addOperation(self)
        return self
    }
    
    override func with(priority: Float) -> Self {
        guard let queuePriority = QueuePriority(priority: priority) else { return self }
        self.queuePriority = queuePriority
        task?.priority = priority
        return self
    }
    
    override func start() {
        print("Start: \(queuePriority.debug) \(task!.priority)")
        super.start()
        guard let task = task else {
            callback(.Failure(error: NSError(domain: "Can not start a urlsessionTask", code: 9999, userInfo: nil)))
            return
        }
        task.resume()
    }
    
    override func cancel() {
        task?.cancel()
        super.cancel()
    }
}

class APIErrorTask<D>: APIGenericTask<APIResponseState<D>> {
    
    private var error: Error
    
    init(error: Error) {
        self.error = error
        super.init()
    }
    
    override func start() {
        super.start()
        callback(.Failure(error: error))
    }
    
    override func then(_ callback: @escaping (APIResponseState<D>) -> Void) -> Self {
        self.callback = callback
        queue?.addOperation(self)
        return self
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
