import Foundation

infix operator ^ { associativity left precedence 160 }
infix operator * { associativity left precedence 150 }
infix operator / { associativity left precedence 150 }
infix operator + { associativity left precedence 140 }
infix operator - { associativity left precedence 140 }

infix operator += { associativity right precedence 90 }
infix operator -= { associativity right precedence 90 }
infix operator *= { associativity right precedence 90 }
infix operator /= { associativity right precedence 90 }

prefix operator ∠ { }
infix operator ∠ { associativity left precedence 160 }

public func + (c1: Complex, c2: Complex) -> Complex { return c1.add(c2) }
public func + (c1: Double,  c2: Complex) -> Complex { return Complex(real: c1).add(c2) }
public func + (c1: Complex, c2: Double ) -> Complex { return c1.add(Complex(real: c2)) }

public func - (c1: Complex, c2: Complex) -> Complex { return c1.subtract(c2) }
public func - (c1: Double,  c2: Complex) -> Complex { return Complex(real: c1).subtract(c2) }
public func - (c1: Complex, c2: Double ) -> Complex { return c1.subtract(Complex(real: c2)) }

public func * (c1: Complex, c2: Complex) -> Complex { return c1.multiply(c2) }
public func * (c1: Double,  c2: Complex) -> Complex { return c2.multiply(c1) }
public func * (c1: Complex, c2: Double ) -> Complex { return c1.multiply(c2) }

public func / (c1: Complex, c2: Complex) -> Complex { return c1.divide(c2) }
public func / (c1: Double,  c2: Complex) -> Complex { return Complex(real: c1).divide(c2) }
public func / (c1: Complex, c2: Double ) -> Complex { return c1.divide(c2) }

public func ^ (c1: Complex, n: Double) -> Complex { return c1.power(n) }
public func ^ (c1: Complex, n: Int) -> Complex { return c1.power(n) }

public func += (inout c1: Complex, c2: Complex) { c1.addInPlace(c2) }
public func += (inout c1: Complex, c2: Double) { c1.addInPlace(Complex(real: c2)) }
public func -= (inout c1: Complex, c2: Complex) { c1.subtractInPlace(c2) }
public func -= (inout c1: Complex, c2: Double) { c1.subtractInPlace(Complex(real: c2)) }
public func *= (inout c1: Complex, c2: Complex) { c1.multiplyInPlace(c2) }
public func *= (inout c1: Complex, c2: Double) { c1.multiplyInPlace(c2) }
public func /= (inout c1: Complex, c2: Complex) { c1.divideInPlace(c2) }
public func /= (inout c1: Complex, c2: Double) { c1.divideInPlace(c2) }

public prefix func ∠ (arg: Double) -> Complex { return cos(arg) + sin(arg) * 𝒊 }
public func ∠ (radius: Double, arg: Double) -> Complex { return ∠arg * radius }
