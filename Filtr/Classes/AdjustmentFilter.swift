//
//  AdjustmentFilterType.swift
//  Filtr
//
//  Created by Daniel Lozano on 6/23/16.
//  Copyright © 2016 danielozano. All rights reserved.
//

import Foundation

/// 'Factory' for instantiating the different kinds of Adjustment Filters
public enum AdjustmentFilter {
    
    public static var fadeFilter: FadeFilter {
        return FadeFilter()
    }
    
}
