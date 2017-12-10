//
//  cameraTrans.swift
//  Gestur
//
//  Created by tk on 08/11/2017.
//  Modified by David on 11/28/2017.
//  Copyright © 2017 tk. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import Vision
import QuartzCore


class cameraController: UIViewController,ARSCNViewDelegate {
    @IBAction func cameraButtonClicked(_ sender: UIBarButtonItem) {
    }
    
    var tempSymbol:String = ""
    var translationArray:[String] = []
    {
        didSet {
            let resetArray:[String] = []
            var bool = true
            
            if(translationArray.count >= 5){
                for i in stride(from: 0, to: 5, by: 1){
                    if (translationArray[i] != translationArray[0]){
                        bool = false
                    }
                }
                
                if (bool == true){
                    if (tempSymbol==""){
                        lblTranslation.text = lblTranslation.text! + " " + translationArray[0]
                        tempSymbol = translationArray[0]
                    }
                    if((tempSymbol != translationArray[0]) && tempSymbol != ""){
                        lblTranslation.text = lblTranslation.text! + " " + translationArray[0]
                        tempSymbol = translationArray[0]
                    }
                    
                }
                translationArray = resetArray
            }
        }
    }
    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var textOut: UILabel!
    @IBOutlet var lblTranslation: UILabel!
    @IBAction func dismissView(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion:nil)
    }
    let dispatchQueueML = DispatchQueue(label: "com.hw.dispatchqueueml") // A Serial Queue
    var visionRequests = [VNRequest]()
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        lblTranslation.text = "Translation: "
        let customColor = UIColor(red:51/255, green:140/255, blue:133/255, alpha:1.0)
        textOut.layer.backgroundColor  = customColor.cgColor
        textOut.layer.cornerRadius = 8
        textOut.alpha = 0.7
        
        lblTranslation.layer.backgroundColor  = customColor.cgColor
        lblTranslation.alpha = 0.7
        
        // --- ARKIT ---
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = false
        
        // Create a new scene
        let scene = SCNScene() // SCNScene(named: "art.scnassets/ship.scn")!
        
        // Set the scene to the view
        sceneView.scene = scene
        
        // --- ML & VISION ---
        
        // Setup Vision Model
        guard let selectedModel = try? VNCoreMLModel(for: v1().model) else {
            fatalError("Could not load model. Ensure model has been drag and dropped (copied) to XCode Project. Also ensure the model is part of a target (see: https://stackoverflow.com/questions/45884085/model-is-not-part-of-any-target-add-the-model-to-a-target-to-enable-generation ")
        }
        
        // Set up Vision-CoreML Request
        let classificationRequest = VNCoreMLRequest(model: selectedModel, completionHandler: classificationCompleteHandler)
        classificationRequest.imageCropAndScaleOption = VNImageCropAndScaleOption.centerCrop // Crop from centre of images and scale to appropriate size.
        visionRequests = [classificationRequest]
        
        // Begin Loop to Update CoreML
        loopCoreMLUpdate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    // MARK: - ARSCNViewDelegate
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        DispatchQueue.main.async {
            // Do any desired updates to SceneKit here.
        }
    }
    
    // MARK: - MACHINE LEARNING
    
    func loopCoreMLUpdate() {
        // Continuously run CoreML whenever it's ready. (Preventing 'hiccups' in Frame Rate)
        dispatchQueueML.async {
            // 1. Run Update.
            self.updateCoreML()
            // 2. Loop this function.
            self.loopCoreMLUpdate()
        }
    }
    
    func updateCoreML() {
        // Get Camera Image as RGB
        let pixbuff : CVPixelBuffer? = (sceneView.session.currentFrame?.capturedImage)
        if pixbuff == nil { return }
        let ciImage = CIImage(cvPixelBuffer: pixbuff!)
        
        // Prepare CoreML/Vision Request
        let imageRequestHandler = VNImageRequestHandler(ciImage: ciImage, options: [:])
        
        // Run Vision Image Request
        do {
            try imageRequestHandler.perform(self.visionRequests)
        } catch {
            print(error)
        }
    }
    
    func classificationCompleteHandler(request: VNRequest, error: Error?) {
        // Catch Errors
        if error != nil {
            print("Error: " + (error?.localizedDescription)!)
            return
        }
        guard let observations = request.results else {
            print("No results")
            return
        }
        
        // Get Classifications
        let classifications = observations[0...2] // top 3 results
            .flatMap({ $0 as? VNClassificationObservation })
            .map({ "\($0.identifier) \(String(format:" : %.2f", $0.confidence))" })
            .joined(separator: "\n")
        
        // Render Classifications
        DispatchQueue.main.async {
            
            // Display Top Symbol
            var symbol = ""
            let topPrediction = classifications.components(separatedBy: "\n")[0]
            let topPredictionName = topPrediction.components(separatedBy: ":")[0].trimmingCharacters(in: .whitespaces)
            let topPredictionScore:Float? = Float(topPrediction.components(separatedBy: ":")[1].trimmingCharacters(in: .whitespaces))

            let secondPrediction = classifications.components(separatedBy: "\n")[1]
            let secondPredictionScore:Float? = Float(secondPrediction.components(separatedBy: ":")[1].trimmingCharacters(in: .whitespaces))
            // Only display a prediction if confidence is above 20% && top prediction is 5% more confident than second one
            if (topPredictionScore != nil && topPredictionScore! > 0.20 && (topPredictionScore! - secondPredictionScore!) > 0.05) {
                if (topPredictionName == "FIST") { symbol = "Zero" }
                if (topPredictionName == "PALM") { symbol = "Five" }
                if (topPredictionName == "FINGER") { symbol = "One" }
            }
            self.textOut.text = symbol
            if(symbol != ""){
                self.translationArray.append(symbol)
            }
        }
    }
}
