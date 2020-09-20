//
//  LicensePlateController.swift
//  LicensePlateRecognition
//
//  Created by Shawn Gee on 9/19/20.
//  Copyright © 2020 Swift Student. All rights reserved.
//

import UIKit

class LicensePlateController {
    
    // MARK: - Public Properties
    private(set) var visiblePlates: [LicensePlate] = []
    var licensePlates: [LicensePlate] = []
    
    // MARK: - Private Properties
    
    /// Percentage that plates must overlap to be considered the same plate
    private let overlapPercentage: CGFloat = 0.2
    
    // MARK: - Public Methods
    
    func update(withRects rects: [CGRect]) {
        visiblePlates.removeAll()
        visiblePlates = rects.map { licensePlate(forRect: $0) }
        
        // Remove plates not in visible plates that don't have numbers
        licensePlates.removeAll {
            !visiblePlates.contains($0) && $0.number == nil
        }
    }
    
    // MARK: - Private Methods
    
    private func licensePlate(forRect rect: CGRect) -> LicensePlate {
        let rectArea = rect.width * rect.height
        
        // Check for plate that overlaps rect by a percentage
        var foundIndex: Int?
        
        for (index, plate) in licensePlates.enumerated() {
            let intersection = plate.lastRectInBuffer.intersection(rect)
            let intersectionArea = intersection.width * intersection.height
            
            if intersectionArea / rectArea > overlapPercentage {
                // Found plate
                foundIndex = index
                break
            }
        }
        
        if let foundIndex = foundIndex {
            // Update plate with new rect and return
            var plate = licensePlates[foundIndex]
            plate.lastRectInBuffer = rect
            licensePlates[foundIndex] = plate
            return plate
        }
        
        // Otherwise make new plate
        let plate = LicensePlate(lastRectInBuffer: rect)
        licensePlates.append(plate)
        
        return plate
    }
}
