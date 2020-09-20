//
//  LicensePlateController.swift
//  LicensePlateRecognition
//
//  Created by Shawn Gee on 9/19/20.
//  Copyright © 2020 Swift Student. All rights reserved.
//

import UIKit

protocol LicensePlateControllerDelegate {
    func numberForLicensePlate(_ licensePlate: LicensePlate) -> String?
}

class LicensePlateController {
    
    // MARK: - Public Properties
    var visiblePlates: [LicensePlate] {
        licensePlates.filter { $0.isVisible }
    }
    
    
    // MARK: - Private Properties
    
    /// Percentage that plates must overlap to be considered the same plate
    private var licensePlates: [LicensePlate] = []
    private let overlapPercentage: CGFloat = 0.2
    private let persistenceTime: TimeInterval = 0.2
    
    // MARK: - Public Methods
    
    func update(withRects rects: [CGRect]) {
        // Update plates with rects
        rects.forEach { updateLicensePlate(forRect: $0) }
        
        // Mark plates that haven't appeared in a while as not visible
        let now = Date()
        var indicesToMarkNotVisble: [Int] = []
        
        for (index, plate) in licensePlates.enumerated() {
            if plate.lastSeen.distance(to: now) > persistenceTime {
                indicesToMarkNotVisble.append(index)
            }
        }
        
        for index in indicesToMarkNotVisble {
            var plate = licensePlates[index]
            plate.isVisible = false
            licensePlates[index] = plate
        }
        
        // Remove plates not in visible plates that don't have numbers
        licensePlates.removeAll {
            !$0.isVisible && $0.number == nil
        }
    }
    
    // MARK: - Private Methods
    
    private func updateLicensePlate(forRect rect: CGRect) {
        let rectArea = rect.width * rect.height
        
        // Check for visible plate that overlaps rect by a percentage
        var foundIndex: Int?
        
        for (index, plate) in visiblePlates.enumerated() {
            let intersection = plate.lastRectInBuffer.intersection(rect)
            let intersectionArea = intersection.width * intersection.height
            
            if intersectionArea / rectArea > overlapPercentage {
                // Found plate
                foundIndex = index
                break
            }
        }
        
        if let foundIndex = foundIndex {
            // Update plate with new rect
            var plate = licensePlates[foundIndex]
            plate.lastRectInBuffer = rect
            plate.lastSeen = Date()
            licensePlates[foundIndex] = plate
            return
        }
        
        // Otherwise make new plate
        let plate = LicensePlate(lastRectInBuffer: rect, lastSeen: Date())
        licensePlates.append(plate)
    }
}
