# Filtr

[![Version](https://img.shields.io/cocoapods/v/Filtr.svg?style=flat)](http://cocoapods.org/pods/Filtr)
[![License](https://img.shields.io/cocoapods/l/Filtr.svg?style=flat)](http://cocoapods.org/pods/Filtr)
[![Platform](https://img.shields.io/cocoapods/p/Filtr.svg?style=flat)](http://cocoapods.org/pods/Filtr)

Filtr is a Swift multi-platform (iOS/macOS/tvOS) framework that has 25 built in photo filter effects that you can apply to images in your app. It also has utilities that let you create your own filters with your favorite photo editor, using 3D LUT files.

This framework is what powers the Lochkamera macOS app.

## Installation

Filtr is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "Filtr"
```

## Getting Started

### Filtr

There are 25 built in filters. 10 crazy color ones, 10 extra regular filters, 5 black and white.

**color1** - **color10** <br>
**extra1** - **extra10** <br>
**blackWhite1** - **blackWhite5** <br>

This is how you would use one.

```swift

  // Create an EffectFilter with the type you want.
  let effectFilter = EffectFilter(type: .color3)
  // Apply an input intensity between 0 and 1.0
  effectFilter.inputIntensity = 1.0

  // Filtr also has a FadeFilter, popularized by VSCO and Instagram.
  let fadeFilter = FadeFilter()
  fadeFilter.intensity = 0.33

  // Add both or either effect you want to use to a FilterStack.
  let filterStack = FilterStack()
  filterStack.effectFilter = effectFilter
  filterStack.fadeFilter = fadeFilter

  // Finaly use Filtr to process the image with the filter stack.
  let filteredImage = Filtr.process(inputImage, filterStack: filterStack)

```

### LUTConverter

Filtr uses a 3D Lookup Table (3D LUT) or [Color Cube](https://developer.apple.com/library/content/documentation/GraphicsImaging/Reference/CoreImageFilterReference/#//apple_ref/doc/filter/ci/CIColorCube) to create the filter effects.

You can create your own filters using one of these LUT images as a base.<br>
[32 x 32 identity LUT image](https://github.com/danlozano/Filtr/blob/master/Filtr/Resources/Identity32.png)<br>
[64 x 64 identity LUT image](https://github.com/danlozano/Filtr/blob/master/Filtr/Resources/Identity64.png)<br>

Import them into Photoshop (or your favorite photo editor), apply any color effects to it (only color effects will work, no grains/alphas or any other advanced effects), then save the resulting image.

Then use the LUTConverter class to convert your image into 3D LUT data.

```swift
  let lutImage = UIImage(named: myLut)
  let lutData32 = LUTConverter.cubeDataForLut32(lutImage) // If you use the 32 x 32 LUT image
  let lutData64 = LUTConverter.cubeDataForLut64(lutImage) // Or if you use the 64 x 64 lut image
```

Then use your 3D LUT data to initialize a EffectFilter.

```swift
let effectFilter = EffectFilter(customFilter: lutData32, withDimension: .thirtyTwo)
effectFilter.inputIntensity = 0.7
```

## Author

Daniel Lozano, dan@danielozano.com

## License

Filtr is available under the MIT license. See the LICENSE file for more info.
