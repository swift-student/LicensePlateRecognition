//
//  RecognizeTextOperation.swift
//  LicensePlateRecognition
//
//  Created by Shawn Gee on 9/20/20.
//  Copyright © 2020 Swift Student. All rights reserved.
//

import AVFoundation
import Vision

class RecognizeTextOperation: ConcurrentOperation {
    let cgImage: CGImage
    let region: CGRect
    var recognizedText: String?
    
    private var request: VNRecognizeTextRequest!
    
    private let allowedCharacters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    private let minHeight: CGFloat = 0.25
    
    init(cgImage: CGImage, region: CGRect) {
        self.cgImage = cgImage
        self.region = region
    }
    
    override func main() {
        request = VNRecognizeTextRequest(completionHandler: recognizeTextHandler(request:error:))

        request.recognitionLevel = .fast // set to fast for real-time performance
        request.usesLanguageCorrection = false // license plates aren't usually words
        request.regionOfInterest = region // only process the area within the region of interest
        
        let requestHandler = VNImageRequestHandler(cgImage: cgImage,
                                                   orientation: .currentRearCameraOrientation,
                                                   options: [:])
        do {
            try requestHandler.perform([request])
        } catch {
            print("Error recognizing text in photo \(error)")
            finish()
        }
    }
    
    func recognizeTextHandler(request: VNRequest, error: Error?) {
        defer { self.finish() }
        
        guard let results = request.results as? [VNRecognizedTextObservation] else {
            return
        }
        
        let candidates = results.compactMap { $0.topCandidates(1).first }
        
        // Only consider text over a certain height
        let filteredCandidates = candidates.filter {
            guard let box = try? $0.boundingBox(for: $0.string.startIndex..<$0.string.endIndex) else {
                return false
            }
            
            let height = box.topLeft.y - box.bottomLeft.y
            return height > minHeight
        }
        
        // Sort text left to right
        var sortedCandidates = filteredCandidates.sorted {
            guard let box1 = try? $0.boundingBox(for: $0.string.startIndex..<$0.string.endIndex),
                let box2 = try? $1.boundingBox(for: $1.string.startIndex..<$1.string.endIndex) else {
                return false
            }
            
            return box1.bottomLeft.x < box2.bottomLeft.x
        }
        
        // Try to append candidates to make number that is 5 to 8 characters long
        var number = ""
        
        while number.count < 8 && !sortedCandidates.isEmpty {
            let nextCandidate = sortedCandidates.removeLast()
            let nextNumber = nextCandidate.string.filter { allowedCharacters.contains($0) }
            number.append(nextNumber)
            
            if (5...8).contains(number.count) {
                recognizedText = number
                return
            }
        }
    }
}
