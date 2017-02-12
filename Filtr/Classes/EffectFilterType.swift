//
//  EffectFilterType.swift
//  Filtr
//
//  Created by Daniel Lozano on 6/22/16.
//  Copyright © 2016 danielozano. All rights reserved.
//

import Foundation
#if os(OSX)
    import AppKit
#else
    import UIKit
#endif

extension UIColor {

    convenience init(r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 1) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a)
    }

}

public enum EffectFilterType: String {

    public static let allFilters: [EffectFilterType] = [.none, .color1, .color2, .color3, .color4, .color5, .color6, .color7, .color8, .color9, .color10, .extra1, .extra2, .extra3, .extra4, .extra5, .extra6, .extra7, .extra8, .extra9, .extra10, .blackWhite1, .blackWhite2, .blackWhite3, .blackWhite4, .blackWhite5]

    case none
    case custom
    case color1
    case color2
    case color3
    case color4
    case color5
    case color6
    case color7
    case color8
    case color9
    case color10
    case extra1
    case extra2
    case extra3
    case extra4
    case extra5
    case extra6
    case extra7
    case extra8
    case extra9
    case extra10
    case blackWhite1
    case blackWhite2
    case blackWhite3
    case blackWhite4
    case blackWhite5

    public var filter: EffectFilter {
        return EffectFilter(type: self)
    }
    
    var dataPath: String? {
        guard self != .none, self != .custom else {
            return nil
        }
        
        return bundle.path(forResource: self.rawValue, ofType: "fcube")
    }
    
    private var bundle: Bundle {
        return Bundle(for: FilterStack.self)
    }

    #if os(OSX)
    
    public var mediumThumbnail: NSImage? {
        return bundle.image(forResource: "\(self.rawValue)-medium")
    }

    public var smallThumbnail: NSImage? {
        return bundle.image(forResource: "\(self.rawValue)-small")
    }

    #else

    public var mediumThumbnail: UIImage? {
        return UIImage(named: "\(self.rawValue)-medium", in: bundle, compatibleWith: nil)
    }

    public var smallThumbnail: UIImage? {
        return UIImage(named: "\(self.rawValue)-small", in: bundle, compatibleWith: nil)
    }

    #endif

}

// MARK: UI

extension EffectFilterType {

    var displayText: String {
        switch self {
        case .custom:
            return " C "
        case .none:
            return " - "
        case .color1:
            return "C1"
        case .color2:
            return "C2"
        case .color3:
            return "C3"
        case .color4:
            return "C4"
        case .color5:
            return "C5"
        case .color6:
            return "C6"
        case .color7:
            return "C7"
        case .color8:
            return "C8"
        case .color9:
            return "C9"
        case .color10:
            return "C10"
        case .extra1:
            return "E1"
        case .extra2:
            return "E2"
        case .extra3:
            return "E3"
        case .extra4:
            return "E4"
        case .extra5:
            return "E5"
        case .extra6:
            return "E6"
        case .extra7:
            return "E7"
        case .extra8:
            return "E8"
        case .extra9:
            return "E9"
        case .extra10:
            return "E10"
        case .blackWhite1:
            return "B1"
        case .blackWhite2:
            return "B2"
        case .blackWhite3:
            return "B3"
        case .blackWhite4:
            return "B4"
        case .blackWhite5:
            return "B5"
        }
    }

    var displayColor: UIColor {
        switch self {
        case .custom:
            return UIColor(r: 129, g: 129, b: 129)
        case .none:
            return UIColor(r: 129, g: 129, b: 129)
        case .color1:
            return UIColor(r: 232, g: 208, b: 193)
        case .color2:
            return UIColor(r: 228, g: 191, b: 168)
        case .color3:
            return UIColor(r: 230, g: 172, b: 172)
        case .color4:
            return UIColor(r: 214, g: 167, b: 187)
        case .color5:
            return UIColor(r: 232, g: 217, b: 190)
        case .color6:
            return UIColor(r: 193, g: 224, b: 186)
        case .color7:
            return UIColor(r: 158, g: 204, b: 191)
        case .color8:
            return UIColor(r: 164, g: 202, b: 228)
        case .color9:
            return UIColor(r: 161, g: 169, b: 198)
        case .color10:
            return UIColor(r: 193, g: 180, b: 213)
        case .extra1:
            return UIColor(r: 69, g: 64, b: 95)
        case .extra2:
            return UIColor(r: 38, g: 45, b: 73)
        case .extra3:
            return UIColor(r: 38, g: 61, b: 73)
        case .extra4:
            return UIColor(r: 75, g: 101, b: 115)
        case .extra5:
            return UIColor(r: 145, g: 161, b: 170)
        case .extra6:
            return UIColor(r: 185, g: 197, b: 205)
        case .extra7:
            return UIColor(r: 178, g: 191, b: 210)
        case .extra8:
            return UIColor(r: 207, g: 213, b: 238)
        case .extra9:
            return UIColor(r: 231, g: 207, b: 238)
        case .extra10:
            return UIColor(r: 217, g: 208, b: 220)
        case .blackWhite1:
            return UIColor(r: 217, g: 217, b: 217)
        case .blackWhite2:
            return UIColor(r: 189, g: 189, b: 189)
        case .blackWhite3:
            return UIColor(r: 165, g: 165, b: 165)
        case .blackWhite4:
            return UIColor(r: 129, g: 129, b: 129)
        case .blackWhite5:
            return UIColor(r: 70, g: 70, b: 70)
        }
    }

}
