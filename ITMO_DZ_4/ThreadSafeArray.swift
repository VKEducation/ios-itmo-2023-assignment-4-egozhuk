import Foundation

class ThreadSafeArray<T>  {
    private var array: [T] = []
    private let lock = NSRecursiveLock()
}

extension ThreadSafeArray: RandomAccessCollection {
    typealias Index = Int
    typealias Element = T

    var startIndex: Index { return array.startIndex }
    var endIndex: Index { return array.endIndex }

    subscript(index: Index) -> Element {
        get {
            lock.lock()
            defer { lock.unlock() }
            return array[index]
        }
        
        set {
            lock.lock()
            defer { lock.unlock() }
            array[index] = newValue
        }
    }
    
    func append(_ value: T) {
        lock.lock()
        defer { lock.unlock() }
        array.append(value)
    }
    
    func toString() -> String {
        lock.lock()
        defer {lock.unlock() }
        return "\(array)"
    }
    
    func set(_ value: T, index: Int) {
        lock.lock()
        defer { lock.unlock() }
        self[index] = value
    }
    
    func dropFirst(_ n: Int = 1) -> [Element] {
        lock.lock()
        defer { lock.unlock() }
        return Array(array.dropFirst(n))
    }

    func index(after i: Index) -> Index {
        return array.index(after: i)
    }
    
    func remove(at index: Index) {
        lock.lock()
        defer { lock.unlock() }
        array.remove(at: index)
    }

    func insert(_ element: Element, at index: Index) {
        lock.lock()
        defer { lock.unlock() }
        array.insert(element, at: index)
    }

    func removeAll() {
        lock.lock()
        defer { lock.unlock() }
        array.removeAll()
    }

    var count: Int {
        lock.lock()
        defer { lock.unlock() }
        return array.count
    }

    var isEmpty: Bool {
        lock.lock()
        defer { lock.unlock() }
        return array.isEmpty
    }

    var first: Element? {
        lock.lock()
        defer { lock.unlock() }
        return array.first
    }

    var last: Element? {
        lock.lock()
        defer { lock.unlock() }
        return array.last
    }
}

