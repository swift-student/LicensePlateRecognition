//
//  CapturePhotoOperation.swift
//  LicensePlateRecognition
//
//  Created by Shawn Gee on 9/20/20.
//  Copyright © 2020 Swift Student. All rights reserved.
//

import AVFoundation

class CapturePhotoOperation: ConcurrentOperation, AVCapturePhotoCaptureDelegate {
    var cgImage: CGImage?
    
    func photoOutput(_ output: AVCapturePhotoOutput,
                     didFinishProcessingPhoto photo: AVCapturePhoto,
                     error: Error?) {
        defer { finish() }
        
        if let error = error {
            print(error)
            return
        }
        
        guard let image = photo.cgImageRepresentation()?.takeUnretainedValue() else {
            return
        }
        
        cgImage = image
    }
}

