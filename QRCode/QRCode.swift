//
//  QRCode.swift
//  Example
//
//  Created by Alexander Schuch on 25/01/15.
//  Copyright (c) 2015 Alexander Schuch. All rights reserved.
//

import UIKit

public typealias 🔳 = QRCode

/// QRCode generator
public struct QRCode {
    
    /**
    The level of error correction.
    
    - Low:      7%
    - Medium:   15%
    - Quartile: 25%
    - High:     30%
    */
    public enum ErrorCorrection: String {
        case Low = "L"
        case Medium = "M"
        case Quartile = "Q"
        case High = "H"
    }
    
    /// CIQRCodeGenerator generates 27x27px images per default
    private let DefaultQRCodeSize = CGSize(width: 27, height: 27)
    
    /// Data contained in the generated QRCode
    public let data: NSData
    
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
    
    /// Logo of company
    public var logo: UIImage?
    
    /// Size of logo
    public var logoSize = CGSize(width: 50, height: 50)
    
    // MARK: Init
    
    public init(_ data: NSData) {
        self.data = data
    }
    
    public init?(_ string: String) {
        if let data = string.dataUsingEncoding(NSISOLatin1StringEncoding) {
            self.data = data
        } else {
            return nil
        }
    }
    
    public init?(_ url: NSURL) {
        if let data = url.absoluteString.dataUsingEncoding(NSISOLatin1StringEncoding) {
            self.data = data
        } else {
            return nil
        }
    }
    
    // MARK: Generate QRCode
    
    /// The QRCode's UIImage representation
    public var image: UIImage? {
        guard let ciImage = ciImage else { return nil }
        let _image = UIImage(CIImage: ciImage)
        guard let logo = logo else {
            return _image
        }
        return drawLogo(_image, logoImage: logo, logoSize: logoSize)
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
        
        // Size
        let sizeRatioX = size.width / DefaultQRCodeSize.width
        let sizeRatioY = size.height / DefaultQRCodeSize.height
        let transform = CGAffineTransformMakeScale(sizeRatioX, sizeRatioY)
        guard let transformedImage = colorFilter.outputImage?.imageByApplyingTransform(transform) else { return nil }
        
        return transformedImage
    }
    
    //draw logo in qrcode image
    private func drawLogo(qrImage: UIImage, logoImage: UIImage, logoSize: CGSize) -> UIImage {
        let rect = CGRectMake(0, 0, qrImage.size.width, qrImage.size.height)
        UIGraphicsBeginImageContext(rect.size)
        qrImage.drawInRect(rect)
        
        let x = (rect.width - logoSize.width) * 0.5
        let y = (rect.height - logoSize.height) * 0.5
        logoImage.drawInRect(CGRectMake(x, y, logoSize.width, logoSize.height))
        
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
}
