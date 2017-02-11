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

public enum EffectFilterType: String {

    public static let allFilters: [EffectFilterType] = [.none,
                                                        .color1, .color2, .color3, .color4, .color5, .color6, .color7, .color8, .color9, .color10,
                                                        .extra1, .extra2, .extra3, .extra4, .extra5, .extra6, .extra7, .extra8, .extra9, .extra10,
                                                        .blackWhite1, .blackWhite2, .blackWhite3, .blackWhite4, .blackWhite5]

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
