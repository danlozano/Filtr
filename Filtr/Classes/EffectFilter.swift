//
//  EffectFilter.swift
//  Filtr
//
//  Created by Daniel Lozano on 6/22/16.
//  Copyright © 2016 danielozano. All rights reserved.
//

import Foundation
import CoreImage

public enum CubeDimension: Int {

    case thirtyTwo = 32
    case sixtyFour = 64

}

public class EffectFilter: CIFilter {
    
    // MARK: - Properties
    
    public let type: EffectFilterType

    public var inputImage: CIImage?

    public var inputIntensity: Float = 1.0 {
        didSet{
            colorCubeData = nil
        }
    }

    private var cubeDimension: CubeDimension = .thirtyTwo

    private lazy var colorCubeData: Data! = {
        let data = self.getColorCubeData()
        return data
    }()

    private var customCubeData: Data?

    // MARK: - Init

    public init(customFilter: Data, withDimension dimension: CubeDimension) {
        type = .custom
        customCubeData = customFilter
        cubeDimension = dimension
        super.init()
    }

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

        guard type != .none else {
            return inputImage
        }

        guard let colorCubeData = colorCubeData else {
            return inputImage
        }
        
        let colorCubeFilter = CIFilter(name: "CIColorCubeWithColorSpace")
        colorCubeFilter?.setValue(colorCubeData, forKey: "inputCubeData")
        colorCubeFilter?.setValue(cubeDimension.rawValue, forKey: "inputCubeDimension")
        colorCubeFilter?.setValue(inputImage, forKey: kCIInputImageKey)

        let colorSpace = CGColorSpaceCreateDeviceRGB()
        colorCubeFilter?.setValue(colorSpace, forKey: "inputColorSpace")
        
        guard let image = colorCubeFilter?.outputImage else {
            return inputImage
        }
        
        return image
    }
    
    // MARK: - Color Cube Helper
    
    private func getColorCubeData() -> Data? {
        guard type != .none else {
            return nil
        }

        guard type != .custom else {
            if let data = customCubeData {
                return dataWithIntensity(data)
            } else {
                return nil
            }
        }

        guard let dataPath = type.dataPath,
            let lutData = try? Data(contentsOf: URL(fileURLWithPath: dataPath)) else {
            return  nil
        }

        return dataWithIntensity(lutData)
    }

    private func dataWithIntensity(_ data: Data) -> Data? {
        let interpolatedData: Data?
        if self.inputIntensity == 0 {
            interpolatedData = nil
        } else if self.inputIntensity == 1.0 {
            interpolatedData = data
        } else {
            interpolatedData = LUTConverter.dataInterpolatedWithIdentity(lutData: data,
                                                                 lutDimension: self.cubeDimension.rawValue,
                                                                    intensity: self.inputIntensity)
        }
        return interpolatedData
    }

}
