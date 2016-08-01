import Foundation

public class SharedArray<Element>: CustomStringConvertible {
    
    var array: [Element]
    
    public init() {
        array = [Element]()
    }
    
    public init(count: Int, repeatedValue: Element) {
        array = [Element](count: count, repeatedValue: repeatedValue)
    }
    
    public subscript (index: Int) -> Element {
        get {
            return array[index]
        }
        set {
            array[index] = newValue
        }
    }
    
    public func append(element: Element) {
        array.append(element)
    }
    
    public var count: Int {
        return array.count
    }
    
    public var description: String {
        return array.description
    }
    
}
