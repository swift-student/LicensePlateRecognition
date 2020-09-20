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
    
    // MARK: - Public Properties
    
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
    
    var bufferSize: CGSize? {
        didSet {
            setNeedsLayout()
        }
    }
    
    // MARK: - Private Properties
    
    private let boundingBox = UIView()
    private let detectionOverlay = UIView()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
    
    // MARK: - Overrides
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Handle rotation of videoPlayerView
        if let connection = videoPlayerView.connection,
            connection.isVideoOrientationSupported {
            connection.videoOrientation = .current
        }
        
        updateDetectionOverlayPosition()
    }
    
    // MARK: - Public Methods

    func showPlate(_ licensePlate: LicensePlate) {
        let plateFrame = licensePlate.lastRectInBuffer

        if !boundingBox.isHidden {
            UIView.animate(withDuration: 0.1) {
                self.updateBoxPosition(withPlateFrame: plateFrame)
            }
        } else {
            boundingBox.isHidden = false
        }
    }
    
    func clearAllPlates() {
        boundingBox.isHidden = true
    }
    
    // MARK: - Private Methods
    
    private func setUp() {
        detectionOverlay.frame = .zero
        addSubview(detectionOverlay)
        
        boundingBox.layer.borderColor = UIColor.red.cgColor
        boundingBox.layer.borderWidth = 2.0
        boundingBox.layer.cornerRadius = 6.0
        
        detectionOverlay.addSubview(boundingBox)
    }
    
    private func updateBoxPosition(withPlateFrame plateFrame: CGRect) {
        boundingBox.frame = plateFrame
    }
    
    private func updateDetectionOverlayPosition() {
        guard let bufferSize = bufferSize else { return }
        let bufferAspectRatio = bufferSize.height / bufferSize.width

        let width = max(frame.width, frame.height)
        let scale = width / bufferSize.width
        
        detectionOverlay.bounds = CGRect(origin: CGPoint(x: 0, y: 0), size: bufferSize)
        detectionOverlay.center = center
        
        // Transform detection overlay to match the preview layer so that bounding boxes will
        // line up with the plates being shown.
        if UIDevice.current.orientation.isLandscape {
            // Expand to fill and reverse y axis (video y is opposite of UI)
            detectionOverlay.transform = .init(scaleX: 1.0 * scale, y: -1.0 * scale)
        } else {
            // Do the above, scale y to match x and vice versa, and rotate 90º
            detectionOverlay.transform =
                CGAffineTransform(
                    scaleX: -1.0 * scale * bufferAspectRatio,
                    y: 1.0 * scale / bufferAspectRatio
                ).rotated(by: .pi)
        }
    }
}


