import UIKit

public enum Channel {
    case red
    case green
    case blue
    case alpha
    case grayscale
    
    func extract(_ base: UnsafePointer<UInt8>) -> UInt8 {
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
    
    func fill(_ base: UnsafeMutablePointer<UInt8>, with value: UInt8) {
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

open class PixelData: CustomStringConvertible {
    
    open let width: Int
    open let height: Int
    
    fileprivate let ptr: UnsafeMutablePointer<UInt8>
    fileprivate let len: Int
    
    public init(width: Int, height: Int) {
        self.width = width
        self.height = height
        self.len = width * height * 4
        self.ptr = UnsafeMutablePointer<UInt8>.allocate(capacity: len)
    }
    
    public convenience init(image: UIImage) {
        func normalize(_ length: Int) -> Int {
            return 1 << Int(ceil(log2(Double(length))))
        }
        
        var cgimage = image.cgImage!
        let w0 = cgimage.width, h0 = cgimage.height
        let nw = normalize(w0), nh = normalize(h0)
        if nw != w0 || nh != h0 {
            UIGraphicsBeginImageContext(CGSize(width: nw, height: nh))
            image.draw(in: CGRect(x: 0, y: 0, width: nw, height: nh))
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            cgimage = (newImage?.cgImage!)!
        }
        
        self.init(width: nw, height: nh)
        
        let pixelData = cgimage.dataProvider?.data
        let src_ptr: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        for i in 0..<len {
            ptr[i] = src_ptr[i]
        }
    }
    
    open func getValue(at offset: Int, of channel: Channel) -> UInt8 {
        return channel.extract(ptr.advanced(by: offset * 4))
    }
    
    open func setValue(_ value: UInt8, at offset: Int, of channel: Channel) {
        channel.fill(ptr.advanced(by: offset * 4), with: value)
    }
    
    open func getValue(at point: (x: Int, y: Int), of channel: Channel) -> UInt8 {
        return getValue(at: point.x + point.y * width, of: channel)
    }
    
    open func setValue(_ value: UInt8, at point: (x: Int, y: Int), of channel: Channel) {
        setValue(value, at: point.x + point.y * width, of: channel)
    }
    
    open func clear(_ channel: Channel, with value: UInt8) {
        for i in 0 ..< width * height {
            setValue(value, at: i, of: channel)
        }
    }
    
    open func desaturate() {
        for y in 0..<height {
            for x in 0..<width {
                let grayscale = getValue(at: (x, y), of: .grayscale)
                setValue(grayscale, at: (x, y), of: .grayscale)
            }
        }
    }
    
    open func generateImage() -> UIImage {
        let dst_ptr = UnsafeMutablePointer<UInt8>.allocate(capacity: len)
        for i in 0..<len {
            dst_ptr[i] = ptr[i]
        }
        
        let provider = CGDataProvider(dataInfo: nil, data: ptr, size: len) { _, data, size in
            let raw = unsafeBitCast(data, to: UnsafeMutablePointer<UInt8>.self)
            raw.deallocate(capacity: size)
        }
        
        let image = CGImage(width: width, height: height, bitsPerComponent: 8, bitsPerPixel: 32, bytesPerRow: 4 * width, space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: CGBitmapInfo(), provider: provider!, decode: nil, shouldInterpolate: false, intent: CGColorRenderingIntent.defaultIntent)!
        return UIImage(cgImage: image)
    }
    
    open var description: String {
        return "RGBA[\(width)x\(height)]"
    }
    
    deinit {
        ptr.deallocate(capacity: len)
    }
    
}
