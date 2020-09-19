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
    static var current: CGImagePropertyOrientation {
        orientation(withDeviceOrientation: UIDevice.current.orientation)
    }
    
    static func orientation(withDeviceOrientation deviceOrientation: UIDeviceOrientation) -> CGImagePropertyOrientation {
        
        switch deviceOrientation {
        case UIDeviceOrientation.portraitUpsideDown:
            return .left
        case UIDeviceOrientation.landscapeLeft:
            return .upMirrored
        case UIDeviceOrientation.landscapeRight:
            return .down
        case UIDeviceOrientation.portrait:
            return .up
        default:
            return .up
        }
    }
}
