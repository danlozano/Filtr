//
//  ImageConverter.swift
//  Filtr
//
//  Created by Daniel Lozano on 7/1/16.
//  Copyright © 2016 danielozano. All rights reserved.
//

import Foundation
#if os(OSX)
    import AppKit
#else
    import UIKit
#endif

public struct ImageConverter {
    
    #if os(OSX)
    
    public static func CIImageFrom(_ nsImage: NSImage) -> CIImage? {
        guard let tiffData = nsImage.tiffRepresentation else {
            return nil
        }

        return CIImage(data: tiffData)
    }
    
    public static func CGImageFrom(_ nsImage: NSImage) -> CGImage? {
        return nsImage.cgImage(forProposedRect: nil, context: nil, hints: nil)
    }
    
    public static func NSImageFrom(_ ciImage: CIImage) -> NSImage {
        let rep = NSCIImageRep(ciImage: ciImage)
        let size = NSSize(width: rep.pixelsWide, height: rep.pixelsHigh)
        let image = NSImage(size: size)
        image.addRepresentation(rep)
        return image
    }
    
    public static func imageDataFrom(_ nsImage: NSImage, compression: Float?, type: NSBitmapImageFileType) -> Data? {        
        guard let tiffData = nsImage.tiffRepresentation else {
            return nil
        }
        
        guard let bitmapImageRep = NSBitmapImageRep(data: tiffData) else {
            return nil
        }
        
        var properties: [String : AnyObject] = [:]
        if let compression = compression{
            properties[NSImageCompressionFactor] = compression as AnyObject?
        }
        
        return bitmapImageRep.representation(using: type, properties: properties)
    }
    
    #else

    public static func CIImageFrom(uiImage: UIImage) -> CIImage? {
        return CIImage(image: uiImage)
    }
    
    public static func CGImageFrom(uiImage: UIImage) -> CGImage? {
        return uiImage.cgImage
    }
    
    public static func UIImageFrom(ciImage: CIImage, orientation: UIImageOrientation) -> UIImage {
        let context = CIContext(options: nil)
        let cgImage = context.createCGImage(ciImage, from: ciImage.extent)
        return UIImage(cgImage: cgImage!, scale: 1.0, orientation: orientation)
    }
    
    public static func jpegDataFrom(uiImage: UIImage, compression: Float) -> Data? {
        guard compression >= 0 && compression <= 1.0 else{
            print("Jpeg compression must be between 0.0 and 1.0")
            return nil
        }
        
        return UIImageJPEGRepresentation(uiImage, CGFloat(compression))
    }
    
    #endif
    
}
