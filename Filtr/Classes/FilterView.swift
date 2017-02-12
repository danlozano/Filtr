//
//  FilterView.swift
//  Filtr
//
//  Created by Daniel Lozano Valdés on 2/11/17.
//  Copyright © 2017 danielozano. All rights reserved.
//

import UIKit

public class FilterView: UIView {

    public var filter: EffectFilterType = .none {
        didSet {
            updateView()
        }
    }

    public weak var filterLabel: UILabel!

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
        let label = UILabel(frame: self.frame)
        label.textColor = .white
        label.textAlignment = .center
        addSubview(label)
        filterLabel = label
    }

    func updateView() {
        filterLabel?.text = filter.displayText
        backgroundColor = filter.displayColor
    }

}
