//
//  LPRView.swift
//  LicensePlateRecognition
//
//  Created by Shawn Gee on 9/19/20.
//  Copyright © 2020 Swift Student. All rights reserved.
//

import UIKit
import AVFoundation

class LPRView: UIView {
    
    override class var layerClass: AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }
    
    var videoPlayerView: AVCaptureVideoPreviewLayer {
        return layer as! AVCaptureVideoPreviewLayer
    }
    
    var session: AVCaptureSession? {
        get { return videoPlayerView.session }
        set { videoPlayerView.session = newValue }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard let connection = videoPlayerView.connection else { return }
        
        if connection.isVideoOrientationSupported {
            connection.videoOrientation = .current
        }
    }
}


