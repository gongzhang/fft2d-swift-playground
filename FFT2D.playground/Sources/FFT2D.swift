import UIKit

public func fft(_ input: PixelData, channel: Channel) -> PixelData {
    let len = input.width * input.height
    
    var array = SharedArray(count: len, repeatedValue: Complex())
    fft(array, 0, input, channel, 0, len, 1)
    array = halfShift(array, input.width, input.height)
    array = halfShift(array, input.width, input.height) // again
    array = flipLeftHalf(array, input.width, input.height)
    
    // render to image
    let c = array.array.max { $0.0.radiusSquare < $0.1.radiusSquare }
    let logOfMaxMag = log(9e-3 * c!.radius + 1.0)
    
    let data = PixelData(width: input.width, height: input.height)
    for i in 0 ..< len {
        var color = log(9e-3 * array[i].radius + 1.0)
        color = 255.0 * (color / logOfMaxMag)
        data.setValue(UInt8(color), at: i, of: .grayscale)
    }
    
    return data
}

private func halfShift(_ array: SharedArray<Complex>, _ w: Int, _ h: Int) -> SharedArray<Complex> {
    let ret = SharedArray<Complex>()
    var vOff = h / 2
    for _ in 0 ..< h {
        for x in 0 ..< w / 2 {
            ret.append(array[vOff * w + x])
        }
        vOff += vOff >= h / 2 ? (-h / 2) : (h / 2) + 1
    }
    vOff = h / 2
    for _ in 0 ..< h {
        for x in w / 2 ..< w {
            ret.append(array[vOff * w + x])
        }
        vOff += vOff >= h / 2 ? (-h / 2) : (h / 2) + 1
    }
    return ret;
}

private func flipLeftHalf(_ array: SharedArray<Complex>, _ w: Int, _ h: Int) -> SharedArray<Complex> {
    let ret = SharedArray<Complex>()
    
    for y in 0 ..< h {
        for x in 0 ..< w {
            let dy = x < w / 2 ? h - y - 1 : y
            ret.append(array[dy * w + x])
        }
    }
    
    return ret;
}

private func fft(_ out: SharedArray<Complex>, _ start: Int, _ input: PixelData, _ channel: Channel, _ offset: Int, _ n: Int, _ s: Int) {
    if n <= 1 {
        let value = input.getValue(at: offset, of: channel)
        out[start] = Complex(Double(value), 0)
    } else {
        fft(out, start, input, channel, offset, n / 2, 2 * s)
        fft(out, start + n / 2, input, channel, offset + s, n / 2, 2 * s)
        for k in 0 ..< n / 2 {
            let twiddle = ∠(-2.0 * M_PI * Double(k) / Double(n))
            let t = out[start + k]
            let delta = twiddle * out[start + k + n / 2]
            out[start + k] = t + delta
            out[start + k + n / 2] = t - delta
        }
    }
}
