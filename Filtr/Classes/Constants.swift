//
//  Constants.swift
//  Filtr
//
//  Created by Daniel Lozano on 6/22/16.
//  Copyright © 2016 danielozano. All rights reserved.
//

import Foundation

public enum Constants {
    
    public struct Keys {
        static let effectFilterTypeKey = "effectFilterTypeKey"
        static let effectFilterIntensityKey = "effectFilterIntensityKey"
        static let fadeFilterIntensityKey = "fadeFilterIntensityKey"
    }
    
    public static var documentsDirectory: String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        return paths.first!
    }
    
}
