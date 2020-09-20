//
//  LPRViewController.swift
//  LicensePlateRecognition
//
//  Created by Shawn Gee on 9/19/20.
//  Copyright © 2020 Swift Student. All rights reserved.
//

import UIKit
import AVFoundation
import Vision

class LPRViewController: UIViewController {
    
    // MARK: - Public Properties
    
    var bufferSize: CGSize = .zero
    
    // MARK: - Private Properties
    
    @IBOutlet private var lprView: LPRView!
    
    private let captureSession = AVCaptureSession()
    private let videoDataOutput = AVCaptureVideoDataOutput()
    private let videoDataOutputQueue = DispatchQueue(label: "VideoDataOutput", qos: .userInitiated, attributes: [], autoreleaseFrequency: .workItem)
    private let photoOutput = AVCapturePhotoOutput()
    
    private var requests = [VNRequest]()
    
    private let licensePlateController = LicensePlateController()
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        captureSession.startRunning()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        captureSession.stopRunning()
    }
    
    // MARK: - Private Methods
    
    private func setUp() {
        lprView.videoPlayerView.videoGravity = .resizeAspectFill
        setUpAVCapture()
        try? setUpVision()
    }
    
    private func setUpAVCapture() {
        var deviceInput: AVCaptureDeviceInput!
        
        // Select a video device, make an input
        let videoDevice = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .back).devices.first
        do {
            deviceInput = try AVCaptureDeviceInput(device: videoDevice!)
        } catch {
            print("Could not create video device input: \(error)")
            return
        }
        
        captureSession.beginConfiguration()
        
        captureSession.sessionPreset = .vga640x480 // Model image size is smaller.
        
        // Add a video input
        guard captureSession.canAddInput(deviceInput) else {
            print("Could not add video device input to the session")
            captureSession.commitConfiguration()
            return
        }
        captureSession.addInput(deviceInput)
        
        // Add video output
        if captureSession.canAddOutput(videoDataOutput) {
            captureSession.addOutput(videoDataOutput)
            // Add a video data output
            videoDataOutput.alwaysDiscardsLateVideoFrames = true
            videoDataOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_420YpCbCr8BiPlanarFullRange)]
            videoDataOutput.setSampleBufferDelegate(self, queue: videoDataOutputQueue)
        } else {
            print("Could not add video data output to the session")
            captureSession.commitConfiguration()
            return
        }
        
        let captureConnection = videoDataOutput.connection(with: .video)
        // Always process the frames
        captureConnection?.isEnabled = true
        
        // Get buffer size to allow for determining recognized license plate positions
        // relative to the video ouput buffer size
        do {
            try videoDevice!.lockForConfiguration()
            let dimensions = CMVideoFormatDescriptionGetDimensions((videoDevice?.activeFormat.formatDescription)!)
            bufferSize.width = CGFloat(dimensions.width)
            bufferSize.height = CGFloat(dimensions.height)
            videoDevice!.unlockForConfiguration()
        } catch {
            print(error)
        }
        
        // Add photo output
        if captureSession.canAddOutput(photoOutput) {
            photoOutput.isHighResolutionCaptureEnabled = true
            captureSession.addOutput(photoOutput)
        }
    
        captureSession.commitConfiguration()
    
        lprView.bufferSize = bufferSize
        lprView.session = captureSession
    }
    
    private func setUpVision() throws {
        let visionModel = try VNCoreMLModel(for: LicensePlateDetector().model)
        
        let objectRecognition = VNCoreMLRequest(model: visionModel) { [weak self] request, error in
            guard let results = request.results as? [VNRecognizedObjectObservation] else { return }
            self?.processResults(results)
        }
        
        self.requests = [objectRecognition]
    }
    
    private func processResults(_ results: [VNRecognizedObjectObservation]) {
        let rects = results.map {
            VNImageRectForNormalizedRect($0.boundingBox,
                                         Int(bufferSize.width),
                                         Int(bufferSize.height))
        }
        
        let platesToGetNumbersFor = licensePlateController.updateLicensePlates(withRects: rects)
        
        if !platesToGetNumbersFor.isEmpty {
            let captureOperation = CapturePhotoOperation()
            queue.addOperation(captureOperation)
            let photoSettings = AVCapturePhotoSettings()
            photoSettings.isHighResolutionPhotoEnabled = true
            photoOutput.capturePhoto(with: photoSettings, delegate: captureOperation)
        }
        
        DispatchQueue.main.async {
            self.lprView.licensePlates = Array(self.licensePlateController.licensePlates)
        }
    }
    
    private let queue = OperationQueue()
}

// MARK: - Video Data Output Delegate

extension LPRViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput,
                       didOutput sampleBuffer: CMSampleBuffer,
                       from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        
        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer,
                                                        orientation: .currentRearCameraOrientation,
                                                        options: [:])
        do {
            try imageRequestHandler.perform(self.requests)
        } catch {
            print(error)
        }
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput,
                       didDrop didDropSampleBuffer: CMSampleBuffer,
                       from connection: AVCaptureConnection) {
        // print("frame dropped")
    }
}
