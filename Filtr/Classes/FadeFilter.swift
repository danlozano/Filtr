//
//  FadeFilter.swift
//  Filtr
//
//  Created by Daniel Lozano on 6/23/16.
//  Copyright © 2016 danielozano. All rights reserved.
//

import Foundation
import CoreImage

public class FadeFilter: CIFilter {
    
    public var inputImage: CIImage?

    public var intensity: CGFloat = 0.5 {
        didSet{
            if intensity > 1.0 {
                intensity = 1.0
            } else if intensity < 0 {
                intensity = 0
            }
        }
    }
    
    private let grayColor: (red: CGFloat, green: CGFloat, blue: CGFloat) = (150.0, 150.0, 150.0)
    
    open override var outputImage: CIImage? {
        guard let inputImage = inputImage else {
            return nil
        }
        
        let grayColorWithIntensity = CIColor(red: grayColor.red / 255.0, green: grayColor.green / 255.0, blue: grayColor.blue / 255.0, alpha: intensity)
        
        guard let colorFilter = CIFilter(name: "CIConstantColorGenerator", withInputParameters: [kCIInputColorKey : grayColorWithIntensity]) else {
            return inputImage
        }
        
        guard let colorOutput = colorFilter.outputImage else {
            return inputImage
        }

        let inputParameters: [String : Any] = [kCIInputImageKey : inputImage, kCIInputBackgroundImageKey : colorOutput.cropping(to: inputImage.extent)]
        guard let lightenBlendFilter = CIFilter(name: "CILightenBlendMode", withInputParameters: inputParameters) else {
            return inputImage
        }
        
        guard let outputImage = lightenBlendFilter.outputImage else {
            return inputImage
        }
        
        return outputImage
    }
    
}
