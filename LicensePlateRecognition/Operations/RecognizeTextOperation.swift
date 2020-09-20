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
    
    var request: VNRecognizeTextRequest!
    
    init(cgImage: CGImage, region: CGRect) {
        self.cgImage = cgImage
        self.region = region
    }
    
    override func main() {
        request = VNRecognizeTextRequest(completionHandler: recognizeTextHandler(request:error:))

        request.recognitionLevel = .fast
        request.usesLanguageCorrection = false
        request.regionOfInterest = region
        
        let requestHandler = VNImageRequestHandler(cgImage: cgImage,
                                                   orientation: .currentRearCameraOrientation,
                                                   options: [:])
        do {
            try requestHandler.perform([request])
        } catch {
            print("Error recognizing text in photo \(error)")
        }
    }
    
    func recognizeTextHandler(request: VNRequest, error: Error?) {
        defer { self.finish() }
        
        guard let results = request.results as? [VNRecognizedTextObservation] else {
            return
        }
        guard let cadidate = results.first?.topCandidates(1).first else {
            return
        }

        print("Recognized text: \(cadidate.string)")
    }
}
