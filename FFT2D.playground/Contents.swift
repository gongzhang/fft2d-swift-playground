import UIKit

let images = [#imageLiteral(resourceName: "dot.png"), #imageLiteral(resourceName: "stripe.png"), #imageLiteral(resourceName: "fractal.png"), #imageLiteral(resourceName: "lena.jpg")]
let origin = images[3]
let data = PixelData(image: origin)
let result = fft(data, channel: .grayscale)
let fourier = result.generateImage()


