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
    
    var licensePlates: [LicensePlate] {
        queue.sync {
            Array(plates)
        }
    }
    
    /// Returns plates that need numbers and have been tracked for over a certain time
    var licensePlatesWithoutNumbers: [LicensePlate] {
        queue.sync {
            let now = Date()
            return Array(plates.filter {
                $0.number == nil && $0.firstSeen.distance(to: now) > minTrackingTime
            })
        }
    }
    
    // MARK: - Private Properties
    
    private var plates: Set<LicensePlate> = []
    
    /// Make license plate controller thread-safe
    private let queue = DispatchQueue(label: "License Plate Controller Queue")
    
    /// Percentage that plates must overlap to be considered the same plate
    private let overlapPercentage: CGFloat = 0.3
    
    /// Amount of time a license plate should persist after it's last appearance
    private let persistenceTime: TimeInterval = 0.4
    
    private let minTrackingTime: TimeInterval = 0.1
    
    // MARK: - Public Methods
    
    /// Updates the license plates with the rects passed in, removing any plates that
    /// haven't appeared for a certain time
    /// - Parameter rects: The rectangles of detected plates to update.
    func updateLicensePlates(withRects rects: [CGRect]) {
        queue.async {
            // Update plates with new rects
            rects.forEach { self.updateLicensePlate(forRect: $0) }
            
            // Remove plates that haven't appeared in a while
            let now = Date()
            self.plates.subtract(
                self.plates.filter { $0.lastSeen.distance(to: now) > self.persistenceTime }
            )
        }
    }
    
    /// Adds a license plate number to a license plate object.
    /// - Parameters:
    ///   - number: The string to add as the license plate number.
    ///   - licensePlate: The license plate to modify.
    func addNumber(_ number: String, to licensePlate: LicensePlate) {
        queue.async {
            guard var plateToUpdate = self.plates.remove(licensePlate) else { return }
            plateToUpdate.number = number
            self.plates.insert(plateToUpdate)
        }
    }
    
    // MARK: - Private Methods
    
    private func updateLicensePlate(forRect rect: CGRect) {
        let rectArea = rect.width * rect.height
        
        // Check for visible plate that overlaps rect by a percentage
        for plate in Array(plates) {
            let intersection = plate.lastRectInBuffer.intersection(rect)
            let intersectionArea = intersection.width * intersection.height
            
            if intersectionArea / rectArea > overlapPercentage {
                // Found plate, update with new rect and date
                guard var plateToUpdate = plates.remove(plate) else { break }
                plateToUpdate.lastRectInBuffer = rect
                plateToUpdate.lastSeen = Date()
                plates.insert(plateToUpdate)
                return
            }
        }
        
        // Otherwise make new plate
        let now = Date()
        let plate = LicensePlate(lastRectInBuffer: rect, firstSeen: now, lastSeen: now)
        plates.insert(plate)
    }
}
