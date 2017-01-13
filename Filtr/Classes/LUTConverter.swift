//
//  LUTConverter.swift
//  Filtr
//
//  Created by Daniel Lozano on 6/21/16.
//  Copyright © 2016 danielozano. All rights reserved.
//

import Foundation
import CoreImage
import CoreGraphics
import Accelerate
#if os(OSX)
    import AppKit
#else
    import UIKit
#endif

public struct LUTConverter {
    
    #if os(OSX)

    public static func cubeDataForLut32(_ lutImage: NSImage) -> Data? {
        guard let lutCgImage = ImageConverter.CGImageFrom(lutImage) else {
            return nil
        }

        return cubeDataForLut32(lutCgImage)
    }
    
    public static func cubeDataForLut64(_ lutImage: NSImage) -> Data? {
        guard let lutCgImage = ImageConverter.CGImageFrom(lutImage) else {
            return nil
        }
        
        return cubeDataForLut64(lutCgImage)
    }
    
    #else
    
    public static func cubeDataForLut64(lutImage: UIImage) -> Data? {
        guard let lutCgImage = ImageConverter.CGImageFrom(uiImage: lutImage) else {
            return nil
        }

        return cubeDataForLut64(lutCgImage)
    }
    
    public static func cubeDataForLut32(lutImage: UIImage) -> Data? {
        guard let lutCgImage = ImageConverter.CGImageFrom(uiImage: lutImage) else {
            return nil
        }

        return cubeDataForLut32(lutCgImage)
    }
    
    #endif
    
    // MARK: - Cube Data Creation
    
    public static func identityCubeData(withDimension dimension: Int) -> Data? {
        guard dimension == 32 || dimension == 64 else {
            print("Cube dimension must be 32 or 64")
            return nil
        }
        
        let cubeSize = (dimension * dimension * dimension * MemoryLayout<Float>.size * 4)
        let cubeData = UnsafeMutablePointer<Float>.allocate(capacity: cubeSize)
        
        var rgb: [Float] = [0, 0, 0]
        
        var offset = 0
        for z in 0 ..< dimension {
            rgb[2] = Float(z) / Float(dimension) // blue value
            for y in 0 ..< dimension {
                rgb[1] = Float(y) / Float(dimension) // green value
                for x in 0 ..< dimension {
                    rgb[0] = Float(x) / Float(dimension) // red value
                    cubeData[offset]   = rgb[0]
                    cubeData[offset+1] = rgb[1]
                    cubeData[offset+2] = rgb[2]
                    cubeData[offset+3] = 1.0
                    offset += 4
                }
            }
        }

        return Data(bytesNoCopy: cubeData, count: cubeSize, deallocator: .free)
    }
    
    private static func cubeDataForLut64(_ lutImage: CGImage) -> Data? {
        let cubeDimension = 64
        let cubeSize = (cubeDimension * cubeDimension * cubeDimension * MemoryLayout<Float>.size * 4)

        let imageWidth = lutImage.width
        let imageHeight = lutImage.height
        let rowCount = imageHeight / cubeDimension
        let columnCount = imageWidth / cubeDimension
        
        guard ((imageWidth % cubeDimension == 0) || (imageHeight % cubeDimension == 0) || (rowCount * columnCount == cubeDimension)) else {
            print("Invalid LUT")
            return nil
        }
        
        let bitmapData = createRGBABitmapFromImage(lutImage)
        let cubeData = UnsafeMutablePointer<Float>.allocate(capacity: cubeSize)

        var bitmapOffset: Int = 0
        var z: Int = 0
        for _ in 0 ..< rowCount{ // ROW
            for y in 0 ..< cubeDimension{
                let tmp = z
                for _ in 0 ..< columnCount{ // COLUMN
                    let dataOffset = (z * cubeDimension * cubeDimension + y * cubeDimension) * 4
                    var divider: Float = 255.0
                    vDSP_vsdiv(&bitmapData[bitmapOffset], 1, &divider, &cubeData[dataOffset], 1, UInt(cubeDimension) * 4)
                    bitmapOffset += cubeDimension * 4
                    z += 1
                }
                z = tmp
            }
            z += columnCount
        }
        
        free(bitmapData)
        return Data(bytesNoCopy: cubeData, count: cubeSize, deallocator: .free)
    }
    
    private static func cubeDataForLut32(_ lutImage: CGImage) -> Data? {
        let cubeDimension: Int = 32
        let cubeSize: Int = (cubeDimension * cubeDimension * cubeDimension * MemoryLayout<Float>.size * 4)

        let imageWidth = lutImage.width
        let imageHeight = lutImage.height

        guard ((imageWidth % cubeDimension == 0) || (imageHeight % cubeDimension == 0)) else {
            print("Invalid LUT")
            return nil
        }
        
        let bitmapData = createRGBABitmapFromImage(lutImage)
        let cubeData = UnsafeMutablePointer<Float>.allocate(capacity: cubeSize)

        var offset = 0
        for _ in 0 ..< imageHeight{
            for _ in 0 ..< imageWidth{
                let divider: Float = 255.0
                let red     = Float(bitmapData[offset]) / divider
                let green   = Float(bitmapData[offset+1]) / divider
                let blue    = Float(bitmapData[offset+2]) / divider
                let alpha   = Float(bitmapData[offset+3]) / divider
                cubeData[offset] = red
                cubeData[offset+1] = green
                cubeData[offset+2] = blue
                cubeData[offset+3] = alpha
                offset += 4
            }
        }
        
        free(bitmapData)
        return Data(bytesNoCopy: cubeData, count: cubeSize, deallocator: .free)
    }
    
    // MARK: - Cube Data Interpolation
    
    public static func dataInterpolatedWithIdentity(lutData lut: Data, lutDimension: Int, intensity: Float) -> Data? {
        guard intensity >= 0 && intensity <= 1.0 else {
            print("Intensity must be between 0 and 1")
            return nil
        }
        
        guard lutDimension == 32 || lutDimension == 64 else {
            print("Cube dimension must be 32 or 64")
            return nil
        }
        
        guard let identity = identityCubeData(withDimension: lutDimension) else {
            print("Error creating identity data")
            return nil
        }
        
        guard lut.count == identity.count else {
            print("Lut and identity lengths must match")
            return nil
        }
        
        let size = lut.count
        let lutData = (lut as NSData).bytes.bindMemory(to: Float.self, capacity: lut.count)
        let identityData = (identity as NSData).bytes.bindMemory(to: Float.self, capacity: identity.count)
        var intensity = intensity
        
        let data = UnsafeMutablePointer<Float>.allocate(capacity: size)

        vDSP_vsbsm(lutData, 1, identityData, 1, &intensity, data, 1, UInt(size) / UInt(MemoryLayout<Float>.size));
        vDSP_vadd(data, 1, identityData, 1, data, 1, UInt(size) / UInt(MemoryLayout<Float>.size));
        
        return Data(bytesNoCopy: data, count: size, deallocator: .free)
    }
    
    // MARK: - Bitmap Helper's
    
    fileprivate static func createRGBABitmapFromImage(_ image: CGImage) -> UnsafeMutablePointer<Float> {
        let bitsPerPixel = 32
        let bitsPerComponent = 8
        let bytesPerPixel = bitsPerPixel / bitsPerComponent // 4 bytes = RGBA
        
        let imageWidth = image.width
        let imageHeight = image.height
        
        let bitmapBytesPerRow = imageWidth * bytesPerPixel
        let bitmapByteCount = bitmapBytesPerRow * imageHeight
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        let bitmapData = malloc(bitmapByteCount)
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue).rawValue
        
        let context = CGContext(data: bitmapData, width: imageWidth, height: imageHeight, bitsPerComponent: bitsPerComponent, bytesPerRow: bitmapBytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo)
        
        let rect = CGRect(x: 0, y: 0, width: imageWidth, height: imageHeight)
        
        context?.draw(image, in: rect)
        
        // Convert UInt8 byte array to single precision Float's
        let convertedBitmap = malloc(bitmapByteCount * MemoryLayout<Float>.size)
        vDSP_vfltu8(UnsafePointer<UInt8>(bitmapData!.assumingMemoryBound(to: UInt8.self)), 1,
                    UnsafeMutablePointer<Float>(convertedBitmap!.assumingMemoryBound(to: Float.self)), 1,
                    vDSP_Length(bitmapByteCount))

        free(bitmapData)
        
        return UnsafeMutablePointer<Float>(convertedBitmap!.assumingMemoryBound(to: Float.self))
    }
    
    // MARK: - File Helper's
    
    public static func saveFilterData(_ data: Data, path: String) {
        try? data.write(to: URL(fileURLWithPath: "\(path).fcube"), options: [.atomic])
    }
    
}
