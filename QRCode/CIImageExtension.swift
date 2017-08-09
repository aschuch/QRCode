//
//  CIImageExtension.swift
//  QRCode
//
//  Created by Jaiouch Yaman - Société ID-APPS on 18/12/2015.
//  Copyright © 2015 Alexander Schuch. All rights reserved.
//

#if os(iOS)
    import UIKit

    public typealias Image = UIImage
#endif // iOS

#if os(OSX)
    import Cocoa

    public typealias Image = NSImage
#endif // macOS

internal typealias Scale = (dx: CGFloat, dy: CGFloat)

internal extension CIImage {

    /// Creates an `UIImage` (iOS) / `NSImage` (macOS) with interpolation disabled and scaled given a scale property
    ///
    /// - parameter withScale:  a given scale using to resize the result image
    ///
    /// - returns: an non-interpolated `UIImage`/`NSImage`
    internal func nonInterpolatedImage(withScale scale: Scale = Scale(dx: 1, dy: 1)) -> Image? {
        guard let cgImage = CIContext(options: nil).createCGImage(self, from: self.extent) else { return nil }
        let size = CGSize(width: self.extent.size.width * scale.dx, height: self.extent.size.height * scale.dy)

        #if os(iOS)
            UIGraphicsBeginImageContextWithOptions(size, true, 0)
            guard let context = UIGraphicsGetCurrentContext() else { return nil }
            context.interpolationQuality = .none
            context.translateBy(x: 0, y: size.height)
            context.scaleBy(x: 1.0, y: -1.0)
            context.draw(cgImage, in: context.boundingBoxOfClipPath)
            let result = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        #endif // iOS

        #if os(OSX)
            let source = NSImage(cgImage: cgImage, size: self.extent.size)
            let result = NSImage(size: size)
            result.lockFocus()
            guard let context = NSGraphicsContext.current() else { return nil }
            context.imageInterpolation = .none
            source.draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: size), from: extent, operation: .copy, fraction: 1.0)
            result.unlockFocus()
        #endif // macOS

        return result
    }
}
