//
//  String+Path.swift
//  Filtr
//
//  Created by Daniel Lozano on 6/21/16.
//  Copyright © 2016 danielozano. All rights reserved.
//

import Foundation

public extension String {
    
    public func stringByAppendingPathComponent(_ path: String) -> String {
        let nsString = self as NSString
        return nsString.appendingPathComponent(path) as String
    }
    
}
