//
//  LicensePlateView.swift
//  LicensePlateRecognition
//
//  Created by Shawn Gee on 9/20/20.
//  Copyright © 2020 Swift Student. All rights reserved.
//

import UIKit

/// A view for drawing a bounding box around a license plate
/// along with the plate number if available
class BoundingBoxView: UIView {
    var licensePlate: LicensePlate? {
        didSet {
            updateViews()
        }
    }
    
    private let numberLabel = UILabel()
    private let outline = UIView()
    private let numberLabelHeight: CGFloat = 26.0
    private let cornerRadius: CGFloat = 6.0
    private let borderWidth: CGFloat = 2.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
    
    private func setUp() {
        clipsToBounds = false
        
        outline.layer.borderColor = UIColor.systemRed.cgColor
        outline.layer.borderWidth = borderWidth
        outline.layer.cornerRadius = cornerRadius
        outline.clipsToBounds = true
        
        addSubview(outline)
        
        numberLabel.backgroundColor = .systemRed
        numberLabel.textColor = .white
        numberLabel.font = .systemFont(ofSize: numberLabelHeight, weight: .bold)
        numberLabel.textAlignment = .center
        numberLabel.adjustsFontSizeToFitWidth = true
        numberLabel.clipsToBounds = true
        
        outline.addSubview(numberLabel)
    }
    
    override func layoutSubviews() {
        outline.frame = CGRect(x: bounds.minX,
                               y: bounds.minY,
                               width: bounds.width,
                               height: bounds.height + numberLabelHeight)
        
        numberLabel.frame = CGRect(x: bounds.minX,
                                   y: bounds.maxY,
                                   width: bounds.width,
                                   height: numberLabelHeight)
    }
    
    private func updateViews() {
        guard let licensePlate = licensePlate else { return }
        
        numberLabel.text = licensePlate.number
        numberLabel.transform = .init(scaleX: 1, y: -1)
    }
}
