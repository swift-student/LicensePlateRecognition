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
        
        // Sort candidates by largest text size to smallest
        let sortedCandidates = candidates.sorted { c1, c2 -> Bool in
            guard let box1 = try? c1.boundingBox(for: c1.string.startIndex..<c1.string.endIndex) else {
                return false
            }
            guard let box2 = try? c1.boundingBox(for: c2.string.startIndex..<c2.string.endIndex) else {
                return false
            }

            let c1Height = box1.bottomLeft.y - box1.topLeft.y
            let c2Height = box2.bottomLeft.y - box2.topLeft.y
            
            return c1Height < c2Height
        }
        
        // Grab the largest candidate (avoids smaller text), filter it to only
        // uppercase numbers and letters, and see if it is 5 to 8 characters long
        // which would be valid for a license plate.
        guard let largestCandidate = sortedCandidates.first else { return }
        let filteredNumber = largestCandidate.string.filter { allowedCharacters.contains($0) }
        
        if (5...8).contains(filteredNumber.count) {
            recognizedText = filteredNumber
        }
    }
}
