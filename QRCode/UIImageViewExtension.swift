//
//  UIImageViewExtension.swift
//  Example
//
//  Created by Alexander Schuch on 27/01/15.
//  Copyright (c) 2015 Alexander Schuch. All rights reserved.
//

import UIKit

public extension UIImageView {
    
    /// Creates a new image view with the given QRCode
    ///
    /// - parameter qrCode:      The QRCode to display in the image view
    @available(iOS 9.0, *)
    public convenience init(qrCode: QRCode) {
        self.init(image: qrCode.image)
    }
    
}
