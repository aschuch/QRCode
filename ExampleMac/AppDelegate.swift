//
//  AppDelegate.swift
//  ExampleMac
//
//  Created by Benedikt Terhechte on 05/10/16.
//  Copyright © 2016 Alexander Schuch. All rights reserved.
//

import Cocoa
import QRCodeMac

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!

    @IBOutlet weak var imageViewSmall1: NSImageView!
    @IBOutlet weak var imageViewSmall2: NSImageView!
    @IBOutlet weak var imageViewSmall3: NSImageView!
    @IBOutlet weak var imageViewSmall4: NSImageView!
    @IBOutlet weak var imageViewMedium: NSImageView!
    @IBOutlet weak var imageViewLarge: NSImageView!
    
    
   func applicationDidFinishLaunching(_ aNotification: Notification) {
        // large
        // default
        imageViewLarge.image = {
            var qrCode = QRCode("http://github.com/aschuch/QRCode")!
            qrCode.size = self.imageViewLarge.bounds.size
            qrCode.errorCorrection = .High
            return qrCode.image
        }()
        
        // medium
        // purple
        imageViewMedium.image = {
            var qrCode = QRCode("http://schuch.me")!
            qrCode.size = self.imageViewMedium.bounds.size
            qrCode.color = CIColor(rgba: "8e44ad")
            return qrCode.image
        }()
        
        // small
        // red (inverted)
        imageViewSmall1.image = {
            var qrCode = QRCode("http://objc.at")!
            qrCode.size = self.imageViewSmall1.bounds.size
            qrCode.color = CIColor(rgba: "fff")
            qrCode.backgroundColor = CIColor(rgba: "e74c3c")
            return qrCode.image
        }()
        
        // small
        // green
        imageViewSmall2.image = {
            var qrCode = QRCode("http://apple.com")!
            qrCode.size = self.imageViewSmall1.bounds.size
            qrCode.color = CIColor(rgba: "16a085")
            qrCode.backgroundColor = CIColor(rgba: "000")
            return qrCode.image
        }()
        
        // small
        // orange
        imageViewSmall3.image = {
            var qrCode = QRCode("http://example.com")!
            qrCode.size = self.imageViewSmall1.bounds.size
            qrCode.color = CIColor(rgba: "c0392b")
            qrCode.backgroundColor = CIColor(rgba: "f1c40f")
            return qrCode.image
        }()
        
        
        // small
        // blue
        imageViewSmall4.image = {
            var qrCode = QRCode("http://example.com")!
            qrCode.size = self.imageViewSmall1.bounds.size
            qrCode.color = CIColor(rgba: "2980b9")
            return qrCode.image
        }()
        
    }

 
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

