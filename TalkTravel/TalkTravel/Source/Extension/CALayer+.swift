import UIKit

extension CALayer {
    func makeLayerToImage() -> UIImage? {
        let layerToConvert = self
        UIGraphicsBeginImageContextWithOptions(layerToConvert.bounds.size, layerToConvert.isOpaque, 0.0)
        layerToConvert.render(in: UIGraphicsGetCurrentContext()!)
        let convertedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return convertedImage
    }
}
