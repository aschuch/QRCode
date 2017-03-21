//
//  UIImageExtension.swift
//  Example
//
//  Created by Eric A. Soto on 3/20/17.
//  Copyright © 2017 Alexander Schuch. All rights reserved.
//
// Based on https://gist.github.com/tomasbasham/10533743
// My changes to this code
//   - Updated to support Retina scale during the resizing operation
//
// Usage:
//    image.scaled(to: size)
//    image.scaled(to: size, scalingMode: .aspectFill)
//    image.scaled(to: size, scalingMode: .aspectFit, retainAlpha: true)
//

// MARK: - Image Scaling.
extension UIImage {
    
    /// Represents a scaling mode
    enum ScalingMode {
        case aspectFill
        case aspectFit
        
        /// Calculates the aspect ratio between two sizes
        ///
        /// - parameters:
        ///     - size:      the first size used to calculate the ratio
        ///     - otherSize: the second size used to calculate the ratio
        ///
        /// - return: the aspect ratio between the two sizes
        func aspectRatio(between size: CGSize, and otherSize: CGSize) -> CGFloat {
            let aspectWidth  = size.width/otherSize.width
            let aspectHeight = size.height/otherSize.height
            
            switch self {
            case .aspectFill:
                return max(aspectWidth, aspectHeight)
            case .aspectFit:
                return min(aspectWidth, aspectHeight)
            }
        }
    }
    
    /// Scales an image to fit within a bounds with a size governed by the passed size. Also keeps the aspect ratio.
    ///
    /// - parameter:
    ///     - newSize:     the size of the bounds the image must fit within.
    ///     - scalingMode: the desired scaling mode
    ///     - retainAlpha: will fill any needed padding as an alpha channel (transparent), otherwise, will fill with black
    ///
    /// - returns: a new scaled image.
    func scaled(to newSize: CGSize, scalingMode: UIImage.ScalingMode = .aspectFill, retainAlpha: Bool = true) -> UIImage {
        
        let aspectRatio = scalingMode.aspectRatio(between: newSize, and: size)
        
        /* Build the rectangle representing the area to be drawn */
        var scaledImageRect = CGRect.zero
        
        scaledImageRect.size.width  = size.width * aspectRatio
        scaledImageRect.size.height = size.height * aspectRatio
        scaledImageRect.origin.x    = (newSize.width - size.width * aspectRatio) / 2.0
        scaledImageRect.origin.y    = (newSize.height - size.height * aspectRatio) / 2.0
        
        /* 
         Draw and retrieve the scaled image -
            - opaque (the second parameter) is the opposite of retain alpha (see the comment in the header of this file)
            - scale 0.0 will suppor retina as it will use device scale
         */
        UIGraphicsBeginImageContextWithOptions(newSize, !retainAlpha, 0.0)
        
        draw(in: scaledImageRect)
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return scaledImage!
    }
    
}
