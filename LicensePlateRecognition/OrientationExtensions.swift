//
//  Helpers.swift
//  LicensePlateRecognition
//
//  Created by Shawn Gee on 9/19/20.
//  Copyright © 2020 Swift Student. All rights reserved.
//

import AVFoundation
import UIKit

extension CGImagePropertyOrientation {
    static var currentRearCameraOrientation: CGImagePropertyOrientation {
        self.init(isUsingFrontFacingCamera: false)
    }
    
    init(isUsingFrontFacingCamera: Bool, deviceOrientation: UIDeviceOrientation = UIDevice.current.orientation) {
        switch deviceOrientation {
        case .portrait:
            self = .right
        case .portraitUpsideDown:
            self = .left
        case .landscapeLeft:
            self = isUsingFrontFacingCamera ? .down : .up
        case .landscapeRight:
            self = isUsingFrontFacingCamera ? .up : .down
        default:
            self = .right
        }
    }
}

extension AVCaptureVideoOrientation {
    static var current: AVCaptureVideoOrientation {
        self.init(deviceOrientation: UIDevice.current.orientation)
    }
    
    init(deviceOrientation: UIDeviceOrientation) {
        switch deviceOrientation {
        case .portrait:
            self = .portrait
        case .portraitUpsideDown:
            self = .portraitUpsideDown
        case .landscapeLeft:
            self = .landscapeRight
        case .landscapeRight:
            self = .landscapeLeft
        default:
            self = .portrait
        }
    }
}
