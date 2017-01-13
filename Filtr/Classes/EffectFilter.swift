//
//  EffectFilter.swift
//  Filtr
//
//  Created by Daniel Lozano on 6/22/16.
//  Copyright © 2016 danielozano. All rights reserved.
//

import Foundation
import CoreImage

public class EffectFilter: CIFilter {
    
    // MARK: - Properties
    
    // TODO: Be able to change type, to re-use filter?
    public let type: EffectFilterType

    private let cubeDimension = 32

    public var inputImage: CIImage?

    public var inputIntensity: Float = 1.0 {
        didSet{
            colorCubeData = nil
        }
    }

    private lazy var colorCubeData: Data! = {
        guard let dataPath = self.type.dataPath, let lutData = try? Data(contentsOf: URL(fileURLWithPath: dataPath)) else {
            return  Data() // nil ?
        }

        let data: Data?
        if self.inputIntensity == 0{
            data = nil
        }else if self.inputIntensity == 1.0{
            data = lutData
        }else{
            data = LUTConverter.dataInterpolatedWithIdentity(lutData: lutData, lutDimension: self.cubeDimension, intensity: self.inputIntensity)
        }
        return data
    }()


    // MARK: - Init
    
    public init(type: EffectFilterType) {
        self.type = type
        super.init()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        self.type = .none
        super.init(coder: aDecoder)
    }
    
    // MARK: - CIFilter
    
    public override var outputImage: CIImage? {
        guard let inputImage = inputImage else {
            return nil
        }
        
        guard type != .none, let colorCubeData = colorCubeData else {
            return inputImage
        }
        
        let colorCubeFilter = CIFilter(name: "CIColorCubeWithColorSpace")
        colorCubeFilter?.setValue(colorCubeData, forKey: "inputCubeData")
        colorCubeFilter?.setValue(cubeDimension, forKey: "inputCubeDimension")
        colorCubeFilter?.setValue(inputImage, forKey: kCIInputImageKey)

        let colorSpace = CGColorSpaceCreateDeviceRGB()
        colorCubeFilter?.setValue(colorSpace, forKey: "inputColorSpace")
        
        guard let outputImage = colorCubeFilter?.outputImage else {
            return inputImage
        }
        
        return outputImage
    }
    
    // MARK: - Color Cube Helper
    
//    fileprivate func colorCubeDataForCurrentType() -> Data? {
//        guard let dataPath = type.dataPath, let lutData = try? Data(contentsOf: URL(fileURLWithPath: dataPath)) else {
//            return  nil
//        }
//        
//        let data: Data?
//        
//        if inputIntensity == 0{
//            data = nil
//        }else if inputIntensity == 1.0{
//            data = lutData
//        }else{
//            data = LUTConverter.dataInterpolatedWithIdentity(lutData: lutData, lutDimension: cubeDimension, intensity: inputIntensity)
//        }
//        
//        return data
//    }
    
}
