//
//  ViewController.swift
//  CoreML-MNIST
//
//  Created by George Kortsaridis on 19/06/2019.
//  Copyright © 2019 Bastionware. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var drawView: DrawView!
    @IBOutlet weak var numberLabel: UILabel!
    
    let model = MNISTClassifier()
    let context = CIContext()
    var pixelBuffer: CVPixelBuffer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        numberLabel.isHidden = true
        
        // Set the pixel buffer dimensions - Remember it's grayscale
        let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue,
                     kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
        CVPixelBufferCreate(kCFAllocatorDefault,
                            28,
                            28,
                            kCVPixelFormatType_OneComponent8,
                            attrs,
                            &pixelBuffer)
    }
    @IBAction func clearInput(_ sender: Any) {
        drawView.lines = []
        drawView.setNeedsDisplay()
        numberLabel.isHidden = true
    }
    
    @IBAction func predict(_ sender: Any) {
        // Fancy Image conversions
        let viewContext = drawView.getViewContext()
        let cgImage = viewContext?.makeImage()
        let ciImage = CIImage(cgImage: cgImage!)
        context.render(ciImage, to: pixelBuffer!)
        // Predict
        let output = try? model.prediction(image: pixelBuffer!)
        // Output
        numberLabel.text = output?.classLabel.description
        numberLabel.isHidden = false
    }
    
}

