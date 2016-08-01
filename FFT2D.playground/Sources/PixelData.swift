import UIKit

public enum Channel {
    case red
    case green
    case blue
    case alpha
    case grayscale
    
    func extract(base: UnsafePointer<UInt8>) -> UInt8 {
        switch self {
        case .red:      return base[0]
        case .green:    return base[1]
        case .blue:     return base[2]
        case .alpha:    return base[3]
        case .grayscale:
            let r = Double(base[0]), g = Double(base[1]), b = Double(base[2])
            let gray = r * 0.299 + g * 0.587 + b * 0.114
            return UInt8(gray)
        }
    }
    
    func fill(base: UnsafeMutablePointer<UInt8>, with value: UInt8) {
        switch self {
        case .red:      base[0] = value
        case .green:    base[1] = value
        case .blue:     base[2] = value
        case .alpha:    base[3] = value
        case .grayscale:
            base[0] = value
            base[1] = value
            base[2] = value
            base[3] = 255
        }
    }
}

public class PixelData: CustomStringConvertible {
    
    public let width: Int
    public let height: Int
    
    private let ptr: UnsafeMutablePointer<UInt8>
    private let len: Int
    
    public init(width: Int, height: Int) {
        self.width = width
        self.height = height
        self.len = width * height * 4
        self.ptr = UnsafeMutablePointer<UInt8>.alloc(len)
    }
    
    public convenience init(image: UIImage) {
        func normalize(length: Int) -> Int {
            return 1 << Int(ceil(log2(Double(length))))
        }
        
        var cgimage = image.CGImage!
        let w0 = CGImageGetWidth(cgimage), h0 = CGImageGetHeight(cgimage)
        let nw = normalize(w0), nh = normalize(h0)
        if nw != w0 || nh != h0 {
            UIGraphicsBeginImageContext(CGSize(width: nw, height: nh))
            image.drawInRect(CGRect(x: 0, y: 0, width: nw, height: nh))
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            cgimage = newImage.CGImage!
        }
        
        self.init(width: nw, height: nh)
        
        let pixelData = CGDataProviderCopyData(CGImageGetDataProvider(cgimage))
        let src_ptr: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        for i in 0..<len {
            ptr[i] = src_ptr[i]
        }
    }
    
    public func getValue(at offset: Int, of channel: Channel) -> UInt8 {
        return channel.extract(ptr.advancedBy(offset * 4))
    }
    
    public func setValue(value: UInt8, at offset: Int, of channel: Channel) {
        channel.fill(ptr.advancedBy(offset * 4), with: value)
    }
    
    public func getValue(at point: (x: Int, y: Int), of channel: Channel) -> UInt8 {
        return getValue(at: point.x + point.y * width, of: channel)
    }
    
    public func setValue(value: UInt8, at point: (x: Int, y: Int), of channel: Channel) {
        setValue(value, at: point.x + point.y * width, of: channel)
    }
    
    public func clear(channel: Channel, with value: UInt8) {
        for i in 0 ..< width * height {
            setValue(value, at: i, of: channel)
        }
    }
    
    public func desaturate() {
        for y in 0..<height {
            for x in 0..<width {
                let grayscale = getValue(at: (x, y), of: .grayscale)
                setValue(grayscale, at: (x, y), of: .grayscale)
            }
        }
    }
    
    public func generateImage() -> UIImage {
        let dst_ptr = UnsafeMutablePointer<UInt8>.alloc(len)
        for i in 0..<len {
            dst_ptr[i] = ptr[i]
        }
        
        let provider = CGDataProviderCreateWithData(nil, ptr, len) { _, data, size in
            let raw = unsafeBitCast(data, UnsafeMutablePointer<UInt8>.self)
            raw.dealloc(size)
        }
        
        let image = CGImageCreate(width, height, 8, 32, 4 * width, CGColorSpaceCreateDeviceRGB(), CGBitmapInfo.ByteOrderDefault, provider, nil, false, CGColorRenderingIntent.RenderingIntentDefault)!
        return UIImage(CGImage: image)
    }
    
    public var description: String {
        return "RGBA[\(width)x\(height)]"
    }
    
    deinit {
        ptr.dealloc(len)
    }
    
}
