# QRCode 🔳

[![Build Status](https://travis-ci.org/ekscrypto/QRCode.svg)](https://travis-ci.org/ekscrypto/QRCode)
![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)
![Swift 4.0](https://img.shields.io/badge/Swift-4.0-orange.svg)

A QRCode generator written in Swift.

![QRCode Example](Resources/example.png)

## Overview

Create a new QRCode representing a `URL`, a string or arbitrary data.
The following examples all result in the same QRCode image.

```swift
// URL
let url = URL(string: "http://schuch.me")!
let qrCode = QRCode(url)
qrCode?.image

// String
let qrCode = QRCode("http://schuch.me")
qrCode?.image

// NSData
let data = "http://schuch.me".data(using: .isoLatin1)!
let qrCode = QRCode(data)
qrCode.image
```

### Customize the output image

> Make sure to declare your `QRCode` instance as a variable in order make use of the following features.

**Adjust Output Size**

Change the output size of the QRCode output image via the `size` property.

```swift
qrCode.size = CGSize(width: 300, height: 300)
qrCode.image // UIImage (300x300)
```

**Color**

Modify the colors of the QRCode output image via `color` and `backgroundColor` properties.

```swift
qrCode.color = CIColor(rgba: "16a085")
qrCode.backgroundColor = CIColor(rgba: "000")
qrCode.image // UIImage (green QRCode color and black background)
```

> **Note**: The above examples make use of the `CIColor` extension that ships with this project to create colors based on HEX strings. 

**Error Correction**

QR codes support a configurable error correction setting. This controls how much of the generated image can be damaged or occluded, while still allowing for the code to be recognized correctly.

To set error correction:

```swift
qrCode.errorCorrection = .High
```

If you do not declare this property, the default will be `.Low`.

Valid values and the corresponding error correction ability are:

| Parameter Val | Correction Ability |
| ------------- | ------------------ |
| Low	        | Approx 7%          |
| Medium	    | Approx 15%         |
| Quartile      | Approx 25%         |
| High          | Approx 30%         |

> For more information on Error Correction, see [QRcode.com](http://www.qrcode.com/en/about/error_correction.html).

*Why would you want higher error correction?*

Setting error correction above the default of Low allows you to create a QR code that can be damaged or covered but still scanned correctly. This allows for wear (if on a printed code) but also allows the use of graphics on top of the code. Therefore, QR codes can include a logo or other branding right over the qr code image (covering a part of it) and still will work. Note, however, that a higher amount of error correction also means that the QR code will be more "dense" (and therefore limits how small it might be printed/displayed.)

### UIImageView extension

For convenience, a `UIImageView` extension is provided to directly initialize an image view with an instance of `QRCode`.

```swift
let imageView = UIImageView(qrCode: qrCode)
```

### Emoji alias

In case you love emoji as much as I do, make sure to create your `QRCode` instance using the 🔳 typealias.

```swift
let qrCode = 🔳("http://example.com")
```

## Version Compatibility

Current Swift compatibility breakdown:

| Swift Version | Framework Version |
| ------------- | ----------------- |
| 4.0	        | 2.0.1        		|
| 3.0	        | 2.0          		|
| 2.3	        | 1.x          		|
| 2.2           | 0.x          		|

[all releases]: https://github.com/ekscrypto/QRCode/releases

## Installation

#### Carthage

Add the following line to your [Cartfile](https://github.com/Carthage/Carthage/blob/master/Documentation/Artifacts.md#cartfile).

```
github "ekscrypto/QRCode"
```

Then run `carthage update`.

#### Cocoapods

Add the following line to your Podfile.

```
pod "QRCode", :git => "https://github.com/ekscrypto/QRCode.git"
```

Then run `pod install` with Cocoapods 1.5.3 or newer.

#### Manually

Just drag and drop the three `.swift` files in the `QRCode` folder into your project.

## Tests

Open the Xcode project and press `⌘-U` to run the tests.

Alternatively, all tests can be run from the terminal using [xctool](https://github.com/facebook/xctool).

```bash
xctool -scheme QRCodeTests -sdk iphonesimulator test
```

## Todo

* Snapshot Tests
* Support transparent backgrounds

## Contributing

* Create something awesome, make the code better, add some functionality,
  whatever (this is the hardest part).
* [Fork it](http://help.github.com/forking/)
* Create new branch to make your changes
* Commit all your changes to your branch
* Submit a [pull request](http://help.github.com/pull-requests/)


## Contact

Feel free to get in touch.

Original author:
* Website: <http://schuch.me>
* Twitter: [@schuchalexander](http://twitter.com/schuchalexander)

Latest updates:
* Website: <http://soft.io>
* Twitter: [@ekscrypto](https://twitter.com/ekscrypto)

