# OpenAlpha

A Swift package for retrieving images from Sony digital cameras.

## Requirements
- iOS 14.0+
- macOS 10.15+

## Quick Start

**SwiftPM**

To install OpenAlpha using Swift Package Manager, add the following dependency to your Package.swift file:

```swift
.Package(url: "https://github.com/colealanroberts/OpenAlpha/OpenAlpha.git", majorVersion: 1)
```
Alternatively, you can add OpenAlpha to your project by clicking the "+" button in Xcode's "Swift Packages" menu.

**Required Entitlements**

The following entitlements **must** be added to your Xcode target—

- Access Wi-Fi Information
- Access Hotspot Configuration

**Connecting to a Camera**

```swift

import OpenAlpha

let oa = OpenAlpha()
let hotspot = OpenAlpha.Hotspot(ssid: "DIRECT-SSID:ILCE-7M2", passphrase: "1234abcd")

do {
    let ip = try await oa.connect(to: hotspot)
    let media = try await oa.media(ip: ip)
    print(media) // [Media]
} catch {
    fatalError(error.localizedDescription)
}

```
## Working with Hotspots and QR Codes
You can also create a `Hotspot` object by passing a `String` value, which is useful if you have retrieved a hotspot configuration from a QR code. For information on how to scan and process QR codes, see [this tutorial](https://www.hackingwithswift.com/example-code/media/how-to-scan-a-qr-code).

Internally, this initializer makes use of `Scanner` and attempts to construct a valid `Hotspot` object from the String value.

## Accessing Media and Assets

`Media` objects contain three `Asset` properties: `small`, `large`, and `thumbnail`. Each Asset object has a single `data` property, which is a `NSData/Data` object representing a JPEG image. You can use this data to create a `UIImage/NSImage` or similar object:

```swift

let image = UIImage(data: media[0].large.data)
imageView.image = image

```
## Contributing

Contributions to OpenAlpha are welcomed! 

If you would like to report a bug, discuss the current state of the code, submit a fix, or propose a new feature, please use GitHub's Issues and Pull Request features.

## Compatible Cameras
The following camera models have been confirmed to be compatible with OpenAlpha: 

  - [x] [Sony a7 II](https://electronics.sony.com/imaging/interchangeable-lens-cameras/full-frame/p/ilce7m2-b)

> **Note**
> This is not a complete list, please open a PR with the compatible camera model once confirmed.

## License

OpenAlpha is licensed under the MIT License. See [LICENSE](https://github.com/colealanroberts/OpenAlpha/blob/main/LICENSE) for more information.

## Contact

Cole Roberts <a href="https://twitter.com/intent/user?screen_name=colealan"><img src="https://img.shields.io/badge/@colealan-x?color=08a0e9&logo=twitter&logoColor=white" valign="middle" /></a>
