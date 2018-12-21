protocol 可儲存{
    associatedtype Item
    mutating func 存(_ item: Item)
    subscript (第n個 n: Int) -> Item { get }
}

struct IntStack: 可儲存 {
    typealias Item = Int
    
    var items: [Int] = []
    
    mutating func 存(_ item: Int) {
        items.append(item)
    }
    
    subscript(第n個 n: Int) -> Int {
        return items[n]
    }
}

struct Stack<T>: 可儲存 {
    typealias Item = T
    
    var items: [T] = []
    
    mutating func 存(_ item: T) {
        items.append(item)
    }
    
    subscript(第n個 n: Int) -> T {
        return items[n]
    }
}

protocol 可從儲存的內容複製: 可儲存 {
    associatedtype 複製後的容器
//            : 可從儲存的內容複製
//        where Self.複製後的容器.Item == Self.Item
    func 複製(最多n個 n: Int) -> 複製後的容器
}

extension Stack: 可從儲存的內容複製 {
//    func 複製(最多n個 n: Int) -> String {
//        return "不加 Line37 這樣寫可以通過"
//    }
//
//    func 複製(最多n個 n: Int) -> Stack<String> {
//        var result = Stack<String>()
//        result.存("不加 Line38 這樣寫可以通過")
//        return result
//    }
    
    func 複製(最多n個 n: Int) -> Stack {
        var result = Stack()
        for i in 0 ..< min(n, items.count) {
            result.存(items[i])
        }
        return result
    }
}

var stack = Stack<Int>()
stack.存(1)
stack.存(2)
stack.存(3)
stack.存(4)
stack.存(5)
let copyStack = stack.複製(最多n個: 3)
