//
//  ReadPlateNumberOperation.swift
//  LicensePlateRecognition
//
//  Created by Shawn Gee on 9/20/20.
//  Copyright © 2020 Swift Student. All rights reserved.
//

import UIKit

class ReadPlateNumberOperation: ConcurrentOperation {
    
    let region: CGRect
    let completion: (String?) -> Void
    let capturePhotoOperation = CapturePhotoOperation()
    
    
    private var recognizeTextOperation: RecognizeTextOperation?
    
    init(region: CGRect, completion: @escaping (String?) -> Void) {
        self.region = region
        self.completion = completion
    }
    
    override func main() {
        defer {
            finish()
            completion(recognizeTextOperation?.recognizedText)
        }
        
        OperationQueue.current?.addOperations([capturePhotoOperation], waitUntilFinished: true)
        
        guard let image = capturePhotoOperation.cgImage else { return }
        
        recognizeTextOperation = RecognizeTextOperation(cgImage: image, region: region)
        OperationQueue.current?.addOperations([recognizeTextOperation!], waitUntilFinished: true)
    }
}
