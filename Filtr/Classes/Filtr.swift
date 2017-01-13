//
//  Filtr.swift
//  Filtr
//
//  Created by Daniel Lozano on 6/22/16.
//  Copyright © 2016 danielozano. All rights reserved.
//

import Foundation
import CoreImage

#if os(OSX)
import AppKit
#else
import UIKit
#endif

public struct Filtr {
    
    #if os(OSX)
    
    public static func process(_ inputImage: NSImage, filterStack: FilterStack) -> NSImage? {
        guard let ciImage = ImageConverter.CIImageFrom(inputImage) else {
            return nil
        }
                
        guard let filteredCIImage = process(ciImage, filters: filterStack.activeFilters) else {
            return inputImage
        }
        
        return ImageConverter.NSImageFrom(filteredCIImage)
    }
    
    #else
    
    public static func process(inputImage: UIImage, filterStack: FilterStack) -> UIImage? {
        guard let ciImage = ImageConverter.CIImageFrom(uiImage: inputImage) else {
            return nil
        }
        
        guard let filteredCIImage = process(ciImage, filters: filterStack.activeFilters) else {
            return inputImage
        }
    
        return ImageConverter.UIImageFrom(ciImage: filteredCIImage, orientation: inputImage.imageOrientation)
    }
    
    #endif
    
    private static func process(_ inputImage: CIImage, filters: [CIFilter]) -> CIImage? {
        guard filters.count > 0 else{
            return inputImage
        }
        
        var image: CIImage? = inputImage
        
        for filter in filters{
            filter.setValue(image, forKey: kCIInputImageKey)
            image = filter.outputImage
        }
        
        if let image = image, image.extent.isEmpty {
            return inputImage
        }
        
        return image
    }

}
