//
//  cameraML.swift
//  Gestur
//
//  Created by tk on 15/11/2017.
//  Copyright © 2017 tk. All rights reserved.
//


import UIKit
import AVKit
import Vision

class cameraMlController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // start camera session
        let captureSession = AVCaptureSession()
        // set camera type
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        // set up input for camera session
        guard let input = try? AVCaptureDeviceInput(device: captureDevice) else {return}
        
        // put input to camera session
        captureSession.addInput(input)
        
        // start camera session
        captureSession.startRunning()
        
        // create previewLayer which is the camera layer
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        // add camera layer to the view in the viewController
        view.layer.addSublayer(previewLayer!)
        previewLayer!.frame = view.frame
        
        // get camera data output
        let dataOutput = AVCaptureVideoDataOutput()
        // delegated monitering the object itself.
        dataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label:"VideoQueue"))
        captureSession.addOutput(dataOutput)
        
        
    }
   
    
    // function capture each frame in the camera
    func captureOutput(_ output: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, from connection: AVCaptureConnection!) {
        // check if camera captured a frame
        //print("camera was able to capture a frame: ", Date())
        
        // pixel buffer for the frame
        guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else{return}
        // import coreML model
        guard let model = try? VNCoreMLModel(for: SqueezeNet().model) else{return}
        // request CoreML model
        let request = VNCoreMLRequest(model: model)
        { (finishedReq, err) in
            // check err
            //print(finishedReq.results )
            
            // result of the coreML model
            guard let result = finishedReq.results as? [VNClassificationObservation] else {return}
            // get first result
            guard let firstObservation = result.first else {return}
            // print the name of the first result and the confidence of the result
            //print(firstObservation.identifier, firstObservation.confidence)
            
            // use background thread
            DispatchQueue.main.async {
                // create UiTextController
                let textView = UITextView(frame:CGRect(x:0, y:20, width:250, height:50))
                textView.textColor = UIColor.blue
                textView.backgroundColor = UIColor.lightGray
                textView.text = "The object detected is: " + firstObservation.identifier
                // present textView to the main view
                self.view.addSubview(textView)
            }
           
            
            
        }
        
        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options:[:]).perform([request])
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

