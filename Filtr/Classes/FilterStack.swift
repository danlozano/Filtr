//
//  FilterStack.swift
//  Filtr
//
//  Created by Daniel Lozano on 6/22/16.
//  Copyright © 2016 danielozano. All rights reserved.
//

import Foundation
import CoreImage

public class FilterStack {
    
    public var effectFilter: EffectFilter?
    public var fadeFilter: FadeFilter?
    
    public var dictionary: [String : String] {
        var representation: [String : String] = [:]
        
        if let effectFilter = effectFilter {
            representation[Constants.Keys.effectFilterTypeKey] = effectFilter.type.rawValue
            representation[Constants.Keys.effectFilterIntensityKey] = String(effectFilter.inputIntensity)
        }
        
        if let fadeFilter = fadeFilter {
            representation[Constants.Keys.fadeFilterIntensityKey] = String(describing: fadeFilter.intensity)
        }
        
        return representation
    }

    public init() {

    }

    public init(dictionary: [String : String]) {
        if let effectFilterType = dictionary[Constants.Keys.effectFilterTypeKey],
            let type = EffectFilterType(rawValue: effectFilterType){
            
            effectFilter = EffectFilter(type: type)
            if let intensity = dictionary[Constants.Keys.effectFilterIntensityKey],
                let floatIntensity = Float(intensity){
                effectFilter?.inputIntensity = floatIntensity
            }
        }
        
        if let fadeFilterIntensity = dictionary[Constants.Keys.fadeFilterIntensityKey],
            let intensity = Float(fadeFilterIntensity){
            fadeFilter = FadeFilter()
            fadeFilter?.intensity = CGFloat(intensity)
        }
    }
    
    public var activeFilters: [CIFilter] {
        let allFilters: [CIFilter?] = [effectFilter, fadeFilter]
        return allFilters.flatMap({ $0 })
    }
    
}
