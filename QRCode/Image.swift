//
//  Image.swift
//  Example
//
//  Created by Benedikt Terhechte on 05/10/16.
//  Copyright © 2016 Alexander Schuch. All rights reserved.
//

import Foundation
#if os(iOS)
    import UIKit
    
    public typealias Image = UIImage

#else
    import Cocoa
    
    public typealias Image = NSImage

#endif


