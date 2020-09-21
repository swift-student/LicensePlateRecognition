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
    private(set) var licensePlates: Set<LicensePlate> = []
    
    // MARK: - Private Properties
    
    /// Make license plate controller thread-safe
    private let queue = DispatchQueue(label: "License Plate Controller Queue")
    
    /// Percentage that plates must overlap to be considered the same plate
    private let overlapPercentage: CGFloat = 0.2
    
    /// Amount of time a license plate should persist after it's last appearance
    private let persistenceTime: TimeInterval = 0.3
    
    // MARK: - Public Methods
    
    @discardableResult
    func updateLicensePlates(withRects rects: [CGRect]) -> [LicensePlate] {
        queue.sync {
            // Update plates with rects
            rects.forEach { updateLicensePlate(forRect: $0) }
            
            // Remove plates that haven't appeared in a while
            let now = Date()
            licensePlates.subtract(
                licensePlates.filter { $0.lastSeen.distance(to: now) > persistenceTime }
            )
            
            return Array(licensePlates.filter { $0.number == nil })
        }
    }
    
    func addNumber(_ number: String, to licensePlate: LicensePlate) {
        queue.sync {
            guard var plateToUpdate = licensePlates.remove(licensePlate) else { return }
            plateToUpdate.number = number
            licensePlates.insert(plateToUpdate)
        }
    }
    
    // MARK: - Private Methods
    
    private func updateLicensePlate(forRect rect: CGRect) {
        let rectArea = rect.width * rect.height
        
        // Check for visible plate that overlaps rect by a percentage
        for plate in Array(licensePlates) {
            let intersection = plate.lastRectInBuffer.intersection(rect)
            let intersectionArea = intersection.width * intersection.height
            
            if intersectionArea / rectArea > overlapPercentage {
                // Found plate, update with new rect and date
                guard var plateToUpdate = licensePlates.remove(plate) else { break }
                plateToUpdate.lastRectInBuffer = rect
                plateToUpdate.lastSeen = Date()
                licensePlates.insert(plateToUpdate)
                return
            }
        }
        
        // Otherwise make new plate
        let plate = LicensePlate(lastRectInBuffer: rect, lastSeen: Date())
        licensePlates.insert(plate)
    }
}
