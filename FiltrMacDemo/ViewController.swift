//
//  ViewController.swift
//  FiltrMacDemo
//
//  Created by Daniel Lozano on 6/23/16.
//  Copyright © 2016 danielozano. All rights reserved.
//

import Cocoa
import Filtr

class ViewController: NSViewController {
    
    @IBOutlet weak var imageView: NSImageView!
    @IBOutlet weak var filterView: NSImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //imageView.imageScaling = .ScaleAxesIndependently
        //imageView.image = image
        
        let filterImage = EffectFilterType.color2.thumbnail
        filterView.image = filterImage

        testCustomFilter()
        //filter()
        //filterMultipleTest()
        //createfcube()
        //createFcubes()
        //transformLuts()
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    func createfcube(){
        let filterName = "bottom"
        let lutPath = Constants.documentsDirectory.stringByAppendingPathComponent("filtr/\(filterName).tif")
        let lutImage = NSImage(contentsOfFile: lutPath)!
        let lutData = LUTConverter.cubeDataForLut64(lutImage)!
        let path = Constants.documentsDirectory.stringByAppendingPathComponent("filtr/\(filterName).fcube")
        try? lutData.write(to: URL(fileURLWithPath: path), options: .atomic)
    }
    
    func createFcubes(){
        let manager = FileManager()
        
        do {
            
            let lutsURL =  URL(string: Constants.documentsDirectory.stringByAppendingPathComponent("filtr/otherluts"))!
            let contents = try manager.contentsOfDirectory(at: lutsURL,
                                                                includingPropertiesForKeys: [],
                                                                options: .skipsHiddenFiles)
            for fileURL in contents {
                let image = NSImage(contentsOf: fileURL)!
                let lutData = LUTConverter.cubeDataForLut32(image)
                
                let fileName = fileURL.lastPathComponent.components(separatedBy: ".").first!
                let filePath = Constants.documentsDirectory.stringByAppendingPathComponent("filtr/otherfcubes/\(fileName).fcube")
                try? lutData!.write(to: URL(fileURLWithPath: filePath), options: .atomic)
                print("SAVING \(fileName).fcube")
            }
            
        } catch {
            print("ERROR = \(error)")
        }
    }
    
    func transformLuts(){
        
        let manager = FileManager()
        
        do {
            
            let lutsURL =  URL(string: Constants.documentsDirectory.stringByAppendingPathComponent("filtr/imgly64luts"))!
            let contents = try manager.contentsOfDirectory(at: lutsURL,
                                                                includingPropertiesForKeys: [],
                                                                options: .skipsHiddenFiles)
            
            let inputPath = Constants.documentsDirectory.stringByAppendingPathComponent("filtr/identity32.png")
            let inputImage = NSImage(contentsOfFile: inputPath)!
            let inputCiImage = ImageConverter.CIImageFrom(inputImage)
            
            for fileURL in contents {

                let lutImage = NSImage(contentsOf: fileURL)!
                let lutData = LUTConverter.cubeDataForLut64(lutImage)
                
                let colorCubeFilter = CIFilter(name: "CIColorCubeWithColorSpace")!
                colorCubeFilter.setValue(lutData, forKey: "inputCubeData")
                colorCubeFilter.setValue(64, forKey: "inputCubeDimension")
                colorCubeFilter.setValue(CGColorSpaceCreateDeviceRGB(), forKey: "inputColorSpace")
                colorCubeFilter.setValue(inputCiImage, forKey: kCIInputImageKey)
                
                let image = ImageConverter.NSImageFrom(colorCubeFilter.outputImage!)
                
                let fileName = fileURL.lastPathComponent.components(separatedBy: ".").first!
                
                let pngData = ImageConverter.imageDataFrom(image, compression: nil, type: .PNG)!
                let path = Constants.documentsDirectory.stringByAppendingPathComponent("filtr/imgly32luts/\(fileName).png")
                try? pngData.write(to: URL(fileURLWithPath: path), options: .atomic)
                print("SAVING \(fileName).png")
                
            }
            
        } catch {
            print("ERROR = \(error)")
        }
        
    }
    
    func filterMultipleTest(){
        
        let imagePath = Constants.documentsDirectory.stringByAppendingPathComponent("filtr/orig2.jpg")
        let image = NSImage(contentsOfFile: imagePath)!
        
        for effect in EffectFilterType.allFilters {

            let fileName = effect.rawValue
            print("PROCESSING FILTER = \(fileName)")

            let effectFilter = effect.filter
            effectFilter.inputIntensity = 1.0

            // let fadeFilter = FadeFilter()
            // fadeFilter.intensity = 0.33

            let filterStack = FilterStack()
            filterStack.effectFilter = effectFilter
            //filterStack.fadeFilter = fadeFilter

            let filteredImage = Filtr.process(image, filterStack: filterStack)!

            let jpegData = ImageConverter.imageDataFrom(filteredImage, compression: 1.0, type: .JPEG)!
            let path = Constants.documentsDirectory.stringByAppendingPathComponent("filtr/tests/\(fileName).jpg")
            try? jpegData.write(to: URL(fileURLWithPath: path), options: .atomic)

        }
        
    }

    func filter(){
        
//        let imagePath = Constants.documentsDirectory.stringByAppendingPathComponent("filtr/orig2.jpg")
//        let inputImage = NSImage(contentsOfFile: imagePath)!
//        let inputCiImage = ImageConverter.CIImageFrom(inputImage)
//        
//        let lutPath = Constants.documentsDirectory.stringByAppendingPathComponent("filtr/strange32.tif")
//        let lutImage = NSImage(contentsOfFile: lutPath)!
//        let lutData = LUTConverter.cubeDataForLut32(lutImage)
////        let lutData = LUTConverter.cubeDataForLut64(lutImage)
////        let interpolatedLutData = LUTConverter.dataInterpolatedWithIdentity(lutData: lutData,
////                                                                            lutDimension: 32,
////                                                                            intensity: 0.5)
//        
//        let colorCubeFilter = CIFilter(name: "CIColorCubeWithColorSpace")!
//        colorCubeFilter.setValue(lutData, forKey: "inputCubeData")
//        colorCubeFilter.setValue(32, forKey: "inputCubeDimension")
//        colorCubeFilter.setValue(CGColorSpaceCreateDeviceRGB(), forKey: "inputColorSpace")
//        colorCubeFilter.setValue(inputCiImage, forKey: kCIInputImageKey)
//
//        let filteredImage = ImageConverter.NSImageFrom(colorCubeFilter.outputImage!)
//                
//        let jpegData = ImageConverter.imageDataFrom(filteredImage, compression: 1.0, type: .JPEG)!
//        let path = Constants.documentsDirectory.stringByAppendingPathComponent("filtr/edited.jpg")
//        try? jpegData.write(to: URL(fileURLWithPath: path), options: .atomic)

        // THIS IS THE CORRECT
        
        let effectFilter = EffectFilter(type: .color1)
        effectFilter.inputIntensity = 1.0
        
        // let fadeFilter = FadeFilter()
        // fadeFilter.intensity = 0.33
        
        let filterStack = FilterStack()
        filterStack.effectFilter = effectFilter
        //filterStack.fadeFilter = fadeFilter

        let imagePath = Constants.documentsDirectory.stringByAppendingPathComponent("filtr/orig4.jpg")
        let inputImage = NSImage(contentsOfFile: imagePath)!
        let filteredImage = Filtr.process(inputImage, filterStack: filterStack)!

        // CREATE JPEG DATA
        
        let jpegData = ImageConverter.imageDataFrom(filteredImage, compression: 1.0, type: .JPEG)!
        let path = Constants.documentsDirectory.stringByAppendingPathComponent("filtr/tests/edited.jpg")
        let url = URL(fileURLWithPath: path)
        try? jpegData.write(to: url, options: .atomic)
    }

    func testCustomFilter() {
        let lutPath = Constants.documentsDirectory.stringByAppendingPathComponent("filtr/otherluts/Z32.tif")
        let lutImage = NSImage(contentsOfFile: lutPath)!
        let lutData = LUTConverter.cubeDataForLut32(lutImage)!

        let effectFilter = EffectFilter(customFilter: lutData, withDimension: .thirtyTwo)
        let filterStack = FilterStack()
        filterStack.effectFilter = effectFilter

        let imagePath = Constants.documentsDirectory.stringByAppendingPathComponent("filtr/orig4.jpg")
        let inputImage = NSImage(contentsOfFile: imagePath)!
        let filteredImage = Filtr.process(inputImage, filterStack: filterStack)!

        let jpegData = ImageConverter.imageDataFrom(filteredImage, compression: 1.0, type: .JPEG)!
        let path = Constants.documentsDirectory.stringByAppendingPathComponent("filtr/tests/edited.jpg")
        let url = URL(fileURLWithPath: path)
        try? jpegData.write(to: url, options: .atomic)

    }

}

