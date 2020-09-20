//
//  LicensePlateView.swift
//  LicensePlateRecognition
//
//  Created by Shawn Gee on 9/20/20.
//  Copyright © 2020 Swift Student. All rights reserved.
//

import UIKit

class LicensePlateView: UIView {
    var licensePlate: LicensePlate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
    
    private func setUp() {
        layer.borderColor = UIColor.red.cgColor
        layer.borderWidth = 2.0
        layer.cornerRadius = 6.0
    }
}
