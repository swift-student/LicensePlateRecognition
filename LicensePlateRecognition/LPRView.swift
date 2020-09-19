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
    
    
//    private func drawVisionRequestResults(_ results: [Any]) {
//        CATransaction.begin()
//        CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
//        detectionOverlay.sublayers = nil // remove all the old recognized objects
//        for observation in results where observation is VNRecognizedObjectObservation {
//            guard let objectObservation = observation as? VNRecognizedObjectObservation else {
//                continue
//            }
//            // Select only the label with the highest confidence.
//            let topLabelObservation = objectObservation.labels[0]
//            let objectBounds = VNImageRectForNormalizedRect(objectObservation.boundingBox, Int(bufferSize.width), Int(bufferSize.height))
//
//            let shapeLayer = self.createRoundedRectLayerWithBounds(objectBounds)
//
//            let textLayer = self.createTextSubLayerInBounds(objectBounds,
//                                                            identifier: topLabelObservation.identifier,
//                                                            confidence: topLabelObservation.confidence)
//            shapeLayer.addSublayer(textLayer)
//            detectionOverlay.addSublayer(shapeLayer)
//        }
//        self.updateLayerGeometry()
//        CATransaction.commit()
//    }
//
//    private func setupLayers() {
//        detectionOverlay = CALayer() // container layer that has all the renderings of the observations
//        detectionOverlay.name = "DetectionOverlay"
//        detectionOverlay.bounds = CGRect(x: 0.0,
//                                         y: 0.0,
//                                         width: bufferSize.width,
//                                         height: bufferSize.height)
//        detectionOverlay.position = CGPoint(x: rootLayer.bounds.midX, y: rootLayer.bounds.midY)
//        rootLayer.addSublayer(detectionOverlay)
//    }
//
//    private func updateLayerGeometry() {
//        let bounds = rootLayer.bounds
//        var scale: CGFloat
//
//        let xScale: CGFloat = bounds.size.width / bufferSize.height
//        let yScale: CGFloat = bounds.size.height / bufferSize.width
//
//        scale = fmax(xScale, yScale)
//        if scale.isInfinite {
//            scale = 1.0
//        }
//        CATransaction.begin()
//        CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
//
//        // rotate the layer into screen orientation and scale and mirror
//        detectionOverlay.setAffineTransform(CGAffineTransform(rotationAngle: CGFloat(.pi / 2.0)).scaledBy(x: scale, y: -scale))
//        // center the layer
//        detectionOverlay.position = CGPoint(x: bounds.midX, y: bounds.midY)
//
//        CATransaction.commit()
//
//    }
//
//    private func createTextSubLayerInBounds(_ bounds: CGRect, identifier: String, confidence: VNConfidence) -> CATextLayer {
//        let textLayer = CATextLayer()
//        textLayer.name = "Object Label"
//        let formattedString = NSMutableAttributedString(string: String(format: "\(identifier)\nConfidence:  %.2f", confidence))
//        let largeFont = UIFont(name: "Helvetica", size: 24.0)!
//        formattedString.addAttributes([NSAttributedString.Key.font: largeFont], range: NSRange(location: 0, length: identifier.count))
//        textLayer.string = formattedString
//        textLayer.bounds = CGRect(x: 0, y: 0, width: bounds.size.height - 10, height: bounds.size.width - 10)
//        textLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
//        textLayer.shadowOpacity = 0.7
//        textLayer.shadowOffset = CGSize(width: 2, height: 2)
//        textLayer.foregroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [0.0, 0.0, 0.0, 1.0])
//        textLayer.contentsScale = 2.0 // retina rendering
//        // rotate the layer into screen orientation and scale and mirror
//        textLayer.setAffineTransform(CGAffineTransform(rotationAngle: CGFloat(.pi / 2.0)).scaledBy(x: 1.0, y: -1.0))
//        return textLayer
//    }
//
//    private func createRoundedRectLayerWithBounds(_ bounds: CGRect) -> CALayer {
//        let shapeLayer = CALayer()
//        shapeLayer.bounds = bounds
//        shapeLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
//        shapeLayer.name = "Found Object"
//        shapeLayer.backgroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [1.0, 1.0, 0.2, 0.4])
//        shapeLayer.cornerRadius = 7
//        return shapeLayer
//    }
}


