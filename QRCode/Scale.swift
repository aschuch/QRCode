//
//  Scale.swift
//  Example
//
//  Created by Yaman Jaiouch on 18/12/2015.
//  Copyright © 2015 Alexander Schuch. All rights reserved.
//

import Foundation

internal struct Scale {
    
    // MARK: Properties
    
    /// The x value
    internal var x: CGFloat
    
    /// The y value
    internal var y: CGFloat
    
    /// Same and backed by the `x` property
    internal var width: CGFloat {
        get { return x }
        set { x = newValue }
    }
    
    /// Same and backed by the `y` property
    internal var height: CGFloat {
        get { return y }
        set { y = newValue }
    }
    
    // MARK: Initializers
    
    /// Creates a scale struct given a x and y value
    ///
    /// - parameter x:  the x value
    /// - parameter y:  the y value
    internal init(x: CGFloat, y: CGFloat) {
        self.x = x
        self.y = y
    }
    
    /// Creates a scale struct given a width and height value
    ///
    /// - parameter width:   the width value
    /// - parameter height:  the height value
    internal init(width: CGFloat, height: CGFloat) {
        self.init(x: width, y: height)
    }
    
    /// Creates a scale struct given a value
    /// Using this initializer will result to x == y and width == height
    ///
    /// - parameter value:   the value
    internal init(_ value: CGFloat) {
        self.init(x: value, y: value)
    }
}