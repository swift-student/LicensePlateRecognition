//
//  CapturePhotoOperation.swift
//  LicensePlateRecognition
//
//  Created by Shawn Gee on 9/20/20.
//  Copyright © 2020 Swift Student. All rights reserved.
//

class CapturePhotoOperation: ConcurrentOperation, AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput,
                     didFinishProcessingPhoto photo: AVCapturePhoto,
                     error: Error?) {
        defer { finish() }
        
        if let error = error {
            print(error)
            return
        }
        
        print(photo.cgImageRepresentation())
    }
}
