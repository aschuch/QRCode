//
//  QRCode.swift
//  QRCode
//
//  Created by Alexander Schuch on 25/01/15.
//  Copyright (c) 2015 Alexander Schuch. All rights reserved.
//

import UIKit

public typealias 🔳 = QRCode

/// QRCode generator
public struct QRCode {
    
    /**
    The level of error correction ability. (This controls how much of the generated image can be damaged or occluded, while still allowing for the code to be recognized correctly. Higher values allow for more error but produce a more dense QRCode, restricting how small the code might be printed.)
    
    - Low:      7%
    - Medium:   15%
    - Quartile: 25%
    - High:     30%
     
     These values are as documented on https://developer.apple.com/library/content/documentation/GraphicsImaging/Reference/CoreImageFilterReference/#//apple_ref/doc/filter/ci/CIQRCodeGenerator
     
    */
    public enum ErrorCorrection: String {
        case Low = "L"
        case Medium = "M"
        case Quartile = "Q"
        case High = "H"
        
        var percentCorrection: CGFloat {
            switch self {
            case .Low: return 0.07
            case .Medium: return 0.15
            case .Quartile: return 0.25
            case .High: return 0.30
            }
        }
        
    }
    
    /// Data contained in the generated QRCode
    public let data: Data
    
    /// Foreground color of the output
    /// Defaults to black
    public var color = CIColor(red: 0, green: 0, blue: 0)
    
    /// Background color of the output
    /// Defaults to white
    public var backgroundColor = CIColor(red: 1, green: 1, blue: 1)
    
    /// Size of the output
    public var size = CGSize(width: 200, height: 200)
    
    /// The error correction. The default value is `.Low`.
    public var errorCorrection = ErrorCorrection.Low
    
    /// An optional image to overlay over the code. It will be centered on the code.
    public var overlayImage: UIImage?
    
    /// Overlay Max Percentage. Controls how much of the available "error percentage space" the overlay should use. Note that error correction is an approximation, so this allows you to fine tune how large the overlay ends up. Note that on smaller QRCode sizes, you might want this number to be lower. Default is 50% (0.5).
    public var overlayImagePercentage: CGFloat = 0.50
    
    // MARK: Init
    
    public init(_ data: Data) {
        self.data = data
    }
    
    public init?(_ string: String) {
        if let data = string.data(using: .isoLatin1) {
            self.data = data
        } else {
            return nil
        }
    }
    
    public init?(_ url: URL) {
        if let data = url.absoluteString.data(using: .isoLatin1) {
            self.data = data
        } else {
            return nil
        }
    }
    
    // MARK: Generate QRCode
    
    /// The QRCode's UIImage representation
    public var image: UIImage? {
        guard let ciImage = ciImage else { return nil }
        
        // Size
        let ciImageSize = ciImage.extent.size
        let widthRatio = size.width / ciImageSize.width
        let heightRatio = size.height / ciImageSize.height
        
        return ciImage.nonInterpolatedImage(withScale: Scale(dx: widthRatio, dy: heightRatio))
    }
    
    /**
     The QRCode's UIImage representation with an image overlay.
     
     Notes: 
        * The overlay will be sized down automatically to accomodate error correction. 
        * If your QRCode is small, you might need to set the error correction higher so that the overlay is not too small to be useful.
        * To avoid a fuzzy overlay, the overlay image should be at least as large as your QRCode size * the percentage for error correction that you've selected.
        * The image does not need to be square, so the aspect ratio will be retained.
        * The overlay should be colored to suit your needs before being passed. No auto-tinting will be performed.
        * Overlays work best when they have a solid background that contrasts well with your QRCode color and background color.
        * The overlay will be centerd over the QRCode.
     */
    public var imageWithOverlay: UIImage? {
        guard let ciImage = ciImage else { return nil }
        
        // QR Code Image
        
        // Size
        let ciImageSize = ciImage.extent.size
        let widthRatio = size.width / ciImageSize.width
        let heightRatio = size.height / ciImageSize.height
        
        let qrImage = ciImage.nonInterpolatedImage(withScale: Scale(dx: widthRatio, dy: heightRatio))
        
        guard let overlayImage = overlayImage, let qrImageRendered = qrImage else { return qrImage }
        
        // Overlay Image

        // Overlay Image Size is Calculated based on the QRCode image and the Error Correction so that the QR Code is still decodable. Problem is that the error correction formula is percentage "loss" of the overall image area (WxH). If we calculate percent of W and percent of H indepdendently, we come out pretty short. So, instead we calculate the desired "total" size we could lose, then we calculate the area of partial W x partial H, then we loop increasing max W and max H for our overlay by 1% of the current value until we exceed the desiredArea.
        
        // Calculate percentage of the larger QRCode size (we want to be "under" this to keep the QR Code decodable)
        // Note the overlayImagePercentage allows for padding to not "push" to the limit. On smaller QRCodes, this number might need to be small (0.5 or maybe less). Essentially, this controls how much of the larger QRCode we're willing to lose to the overlay.
        let desiredArea = ((qrImageRendered.size.width * qrImageRendered.size.height) * errorCorrection.percentCorrection) * overlayImagePercentage
        // Initial overlayMaxSize is percentage width x percentage height
        var overlayImageMaxSize = size.applying(CGAffineTransform(scaleX: errorCorrection.percentCorrection, y: errorCorrection.percentCorrection))
        // Figure out the area that we have already at the X percentage of width/height (the area of this rectangle will always be smaller than X % of the area.) There might be an interpolation formula for this calculation, I just could not find one.
        var haveArea = overlayImageMaxSize.width * overlayImageMaxSize.height
        
        // Now, slowly increase the overlayMaxSize checking to ensure we don't exceed the total area we're willing to give up
        repeat {
            overlayImageMaxSize.width = overlayImageMaxSize.width + (overlayImageMaxSize.width * 0.01)
            overlayImageMaxSize.height = overlayImageMaxSize.height + (overlayImageMaxSize.height * 0.01)
            haveArea = overlayImageMaxSize.width * overlayImageMaxSize.height
        } while haveArea < desiredArea
        
        // ASSERT: We now have a rectangle larger in area to the desired area when compared to the original at % W x % H.
        
        // Resize the overlay to be no larger than our max and set to "fit" so that aspect ratio is retained
        let scaledOverlayImage = overlayImage.scaled(to: overlayImageMaxSize, scalingMode: .aspectFit)
        
        // Calculate origin point for the centered overlay
        let overlayX = floor(size.width / 2.0) - floor(scaledOverlayImage.size.width / 2.0)
        let overlayY = floor(size.height / 2.0) - floor(scaledOverlayImage.size.height / 2.0)
        
        // Combine the Images (QRCode Image + Overlay Image)
        let scale: CGFloat = 0.0 // Automatically use scale factor of main screen
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        qrImageRendered.draw(in: CGRect(origin: CGPoint(x: 0,y :0), size: size))
        scaledOverlayImage.draw(in: CGRect(origin: CGPoint(x: overlayX,y :overlayY), size: scaledOverlayImage.size))
        let combinedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Return the combined image
        return combinedImage
    }
    
    /// The QRCode's CIImage representation
    public var ciImage: CIImage? {
        // Generate QRCode
        guard let qrFilter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
        
        qrFilter.setDefaults()
        qrFilter.setValue(data, forKey: "inputMessage")
        qrFilter.setValue(self.errorCorrection.rawValue, forKey: "inputCorrectionLevel")
        
        // Color code and background
        guard let colorFilter = CIFilter(name: "CIFalseColor") else { return nil }
        
        colorFilter.setDefaults()
        colorFilter.setValue(qrFilter.outputImage, forKey: "inputImage")
        colorFilter.setValue(color, forKey: "inputColor0")
        colorFilter.setValue(backgroundColor, forKey: "inputColor1")
        
        return colorFilter.outputImage
    }
}
