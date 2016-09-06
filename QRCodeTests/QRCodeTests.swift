//
//  QRCodeTests.swift
//  QRCodeTests
//
//  Created by Alexander Schuch on 25/01/15.
//  Copyright (c) 2015 Alexander Schuch. All rights reserved.
//

import UIKit
import XCTest
@testable import QRCode

class QRCodeTests: XCTestCase {
    
    func testDefaultValues() {
        let qrCode = QRCode("hello")
        
        XCTAssert(qrCode != nil, "QRCode is nil")
        XCTAssertEqual(CIColor(red: 0, green: 0, blue: 0), qrCode!.color, "Initial color is not black")
        XCTAssertEqual(CIColor(red: 1, green: 1, blue: 1), qrCode!.backgroundColor, "Initial backgroundColor is not white")
        XCTAssertEqual(CGSize(width: 200, height: 200), qrCode!.size, "Initial size is not 200x200")
    }
    
    func testInitWithData() {
        let data = "hello".data(using: .isoLatin1)!
        let qrCode = QRCode(data)
        
        XCTAssertEqual(data, qrCode.data, "data is not equal")
    }
    
    func testInitWithString() {
        let string = "hello"
        let data = string.data(using: .isoLatin1)!
        let qrCode = QRCode(string)
        
        XCTAssert(qrCode != nil, "QRCode is nil")
        XCTAssertEqual(data, qrCode!.data, "data is not equal")
    }

    func testInitWithURL() {
        let url = URL(string: "http://example.com")!
        let data = url.absoluteString.data(using: .isoLatin1)!
        let qrCode = QRCode(url)
        
        XCTAssert(qrCode != nil, "QRCode is nil")
        XCTAssertEqual(data, qrCode!.data, "data is not equal")
    }
    
    func testColor() {
        let red = CIColor(red: 1, green: 0, blue: 0)
        let blue = CIColor(red: 0, green: 0, blue: 1)
        
        var qrCode = QRCode("hello")
        qrCode?.color = red
        qrCode?.backgroundColor = blue
            
        XCTAssert(qrCode != nil, "QRCode is nil")
        XCTAssertEqual(red, qrCode!.color, "color is not red")
        XCTAssertEqual(blue, qrCode!.backgroundColor, "backgroundColor is not blue")
        
        qrCode?.color = blue
        qrCode?.backgroundColor = red
        
        XCTAssertEqual(blue, qrCode!.color, "color is not blue")
        XCTAssertEqual(red, qrCode!.backgroundColor, "backgroundColor is not red")
    }
    
    func testSize() {
        var size = CGSize(width: 400, height: 400)
        
        var qrCode = QRCode("hello")
        qrCode?.size = size
        
        XCTAssert(qrCode != nil, "QRCode is nil")
        XCTAssertEqual(size, qrCode!.size, "size is not equal")
        
        size = CGSize(width: 10.457, height: 12.454)
        qrCode?.size = size
        
        XCTAssertEqual(size, qrCode!.size, "size is not equal")
    }
    
    func testImageSize() {
        let size = CGSize(width: 100, height: 100)
        
        var qrCode = QRCode("hello")
        qrCode?.size = size
        
        let image = qrCode?.image
        
        XCTAssert(qrCode != nil, "QRCode is nil")
        XCTAssert(image != nil, "image is nil")
        XCTAssertEqual(image!.size, size)
    }
}
