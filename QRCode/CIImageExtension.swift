//
//  CIImageExtension.swift
//  Example
//
//  Created by Jaiouch Yaman - Société ID-APPS on 18/12/2015.
//  Copyright © 2015 Alexander Schuch. All rights reserved.
//

import Foundation

internal extension CIImage {
    
    /// Creates an `UIImage` with interpolation disabled and scaled given a scale property
    ///
    /// - parameter withScale:  a given scale using to resize the result image
    ///
    /// - returns: an non-interpolated UIImage
    internal func nonInterpolatedImage(withScale scale: Scale = Scale(1)) -> UIImage {
        let cgImage = CIContext(options: nil).createCGImage(self, fromRect: self.extent)
        let size = CGSize(width: self.extent.size.width * scale.width, height: self.extent.size.height * scale.height)
        
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()
        CGContextSetInterpolationQuality(context, .None)
        CGContextDrawImage(context, CGContextGetClipBoundingBox(context), cgImage)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return result
    }
    
    /// Convenience methods for `nonInterpolatedImage(withScale scale: Scale)` method
    internal func nonInterpolatedImage(withScale scale: CGFloat) -> UIImage {
        return self.nonInterpolatedImage(withScale: Scale(scale))
    }
}