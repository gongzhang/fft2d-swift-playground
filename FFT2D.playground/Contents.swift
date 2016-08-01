import UIKit

let images = [[#Image(imageLiteral: "dot.png")#], [#Image(imageLiteral: "stripe.png")#], [#Image(imageLiteral: "fractal.png")#], [#Image(imageLiteral: "lena.jpg")#]]
let origin = images[3]
let data = PixelData(image: origin)
let result = fft(data, channel: .grayscale)
let fourier = result.generateImage()


