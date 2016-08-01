import Foundation

public let 𝒊 = Complex(0, 1)

public struct Complex: Equatable, Hashable, CustomStringConvertible, IntegerLiteralConvertible, FloatLiteralConvertible {
    
    /// The real part of the complex number.
    public var x: Double = 0
    
    /// The imaginary part of the complex number.
    public var y: Double = 0
    
    public init() {}
    
}

extension Complex {
    
    public var real: Double { get { return x } set { x = newValue } }
    public var imaginary: Double { get { return y } set { y = newValue } }
    
    public init (_ real: Double, _ imagine: Double) {
        self.x = real
        self.y = imagine
    }
    
    public init (real: Double) {
        self.init(real, 0)
    }
    
    public init(integerLiteral value: Int) {
        self.init(real: Double(value))
    }
    
    public init(floatLiteral value: Double) {
        self.init(real: value)
    }
    
    public init (imagine: Double) {
        self.init(0, imagine)
    }
    
    public subscript(index: Int) -> Double {
        switch index {
        case 0: return x
        case 1: return y
        default: fatalError("only 0 and 1 are allowed")
        }
    }
    
    public var radiusSquare: Double { return x * x + y * y }
    public var radius: Double { return sqrt(radiusSquare) }
    public var arg: Double { return atan2(y, x) }
    
    public var hashValue: Int {
        return x.hashValue &+ y.hashValue
    }
    
    public var description: String {
        if x != 0 {
            if y > 0 {
                return "\(x)+\(y)𝒊"
            } else if y < 0 {
                return "\(x)-\(-y)𝒊"
            } else {
                return "\(x)"
            }
        } else {
            if y == 0 {
                return "0"
            } else {
                return "\(y)𝒊"
            }
        }
    }
    
}

public func ==(c1: Complex, c2: Complex) -> Bool {
    return c1.x == c2.x && c1.y == c2.y
}

public extension Complex {
    
    @warn_unused_result
    public func conjugate() -> Complex {
        return Complex(x, -y)
    }
    
    @warn_unused_result
    public func add(n: Complex) -> Complex {
        return Complex(x + n.x, y + n.y)
    }
    
    @warn_unused_result
    public func subtract(n: Complex) -> Complex {
        return Complex(x - n.x, y - n.y)
    }
    
    @warn_unused_result
    public func multiply(n: Double) -> Complex {
        return Complex(x * n, y * n)
    }
    
    @warn_unused_result
    public func multiply(n: Complex) -> Complex {
        return Complex(x * n.x - y * n.y, x * n.y + y * n.x)
    }
    
    @warn_unused_result
    public func divide(n: Complex) -> Complex {
        return self.multiply((n.conjugate().divide(n.radiusSquare)))
    }
    
    @warn_unused_result
    public func divide(n: Double) -> Complex {
        return Complex(x / n, y / n)
    }
    
    @warn_unused_result
    public func power(n: Double) -> Complex {
        return pow(radiusSquare, n / 2) * Complex(cos(n * arg), sin(n * arg))
    }
    
    @warn_unused_result
    public func power(n: Int) -> Complex {
        switch n {
        case 0: return 1
        case 1: return self
        case -1: return Complex(real: 1).divide(self)
        case 2: return self.multiply(self)
        case -2: return Complex(real: 1).divide(self.multiply(self))
        default: return power(Double(n))
        }
    }
    
    public mutating func conjugateInPlace() {
        y = -y
    }
    
    public mutating func addInPlace(n: Complex) {
        x += n.x
        y += n.y
    }
    
    public mutating func subtractInPlace(n: Complex) {
        x -= n.x
        y -= n.y
    }
    
    public mutating func multiplyInPlace(n: Double) {
        x *= n
        y *= n
    }
    
    public mutating func multiplyInPlace(n: Complex) {
        self = self.multiply(n)
    }
    
    public mutating func divideInPlace(n: Complex) {
        self = self.divide(n)
    }
    
    public mutating func divideInPlace(n: Double) {
        x /= n
        y /= n
    }
    
}
