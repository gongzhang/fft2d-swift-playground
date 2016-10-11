import Foundation

open class SharedArray<Element>: CustomStringConvertible {
    
    var array: [Element]
    
    public init() {
        array = [Element]()
    }
    
    public init(count: Int, repeatedValue: Element) {
        array = [Element](repeating: repeatedValue, count: count)
    }
    
    open subscript (index: Int) -> Element {
        get {
            return array[index]
        }
        set {
            array[index] = newValue
        }
    }
    
    open func append(_ element: Element) {
        array.append(element)
    }
    
    open var count: Int {
        return array.count
    }
    
    open var description: String {
        return array.description
    }
    
}
