//
//  FilterView.swift
//  Filtr
//
//  Created by Daniel Lozano Valdés on 2/11/17.
//  Copyright © 2017 danielozano. All rights reserved.
//

import UIKit

public class FilterView: UIView {

    var filter: EffectFilterType = .none {
        didSet {
            updateView()
        }
    }

    weak var filterLabel: UILabel!

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    func setup() {
        layer.cornerRadius = 2.0
        filterLabel = UILabel(frame: self.frame)
        filterLabel.textColor = .white
        addSubview(filterLabel)
    }

    func updateView() {
        filterLabel?.text = filter.displayText
        backgroundColor = filter.displayColor
    }

}
