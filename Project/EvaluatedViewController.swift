//
//  EvaluatedViewController.swift
//  Project
//
//  Created by Timi Liljeström on 6.4.2018.
//  Copyright © 2018 Timi Liljeström. All rights reserved.
//

import UIKit
import CoreData
import CoreML
import Vision

class EvaluatedViewController: UIViewController {

    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var saveButton: UIButton!
    
    var status: String = ""
    var pickedImage: UIImage?
    var roundedPrice: Double = 0.0
    
    var alertController: UIAlertController?
    
    let shoesModel = shoe_model()
    let shirtsModel = shirt_model()
    let coatsModel = coats_model()
    let hatsModel = hats_model()
    let glovesModel = gloves_model()
    let pantsModel = pants_model()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "Evaluation"
        
        doEvaluation(image: pickedImage!)
        
        textLabel.text = "Category: "+status
        photoImageView.image = pickedImage
        
        saveButton.layer.cornerRadius = 10
        saveButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        saveButton.backgroundColor = UIColorFromHex(rgbValue: 0x28AE7B, alpha: 1)
    }
    
    func addItem() {
        let context = AppDelegate.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ImageItem")
        let newItem = NSEntityDescription.insertNewObject(forEntityName: "ImageItem", into: context)
        
        request.returnsObjectsAsFaults = false
        
        newItem.setValue(roundedPrice, forKey: "price")
        newItem.setValue(status, forKey: "categoryname")
        
        let imgData = UIImageJPEGRepresentation(pickedImage!, 1)
        newItem.setValue(imgData, forKey: "photo")
        
        print("Data added in ImageItem")
        do {
            try context.save()
            print("SAVED")
            self.showAlertMsg(title: "Saved", message: "Successfully saved!")
            
        } catch {
            print ("Error")
            self.showAlertMsg(title: "Error", message: "Oops! Something went wrong.")
        }
    }
    
    func showAlertMsg(title: String, message: String) {
        
        guard (self.alertController == nil) else {
            print("Alert already displayed")
            return
        }
        
        self.alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Ok", style: .cancel) { (action) in
            print("Alert was closed")
            self.alertController=nil;
            
            // set the navigation to go to main controller when closing the alert window
            var theControllers = [UIViewController]()
            theControllers.append(self.navigationController!.viewControllers.first!)
            theControllers.append(self.navigationController!.viewControllers.last!)
            self.navigationController?.setViewControllers(theControllers, animated: false)
        }
        
        self.alertController!.addAction(cancelAction)
        
        self.present(self.alertController!, animated: true, completion: nil)
    }
    
    func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
    
    func buffer(from image: UIImage) -> CVPixelBuffer? {
        let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue, kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
        var pixelBuffer : CVPixelBuffer?
        let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(image.size.width), Int(image.size.height), kCVPixelFormatType_32ARGB, attrs, &pixelBuffer)
        guard (status == kCVReturnSuccess) else {
            return nil
        }
        
        CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer!)
        
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: pixelData, width: Int(image.size.width), height: Int(image.size.height), bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!), space: rgbColorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)
        
        context?.translateBy(x: 0, y: image.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        
        UIGraphicsPushContext(context!)
        image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        UIGraphicsPopContext()
        CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        
        return pixelBuffer
    }
    
    func myResultsMethod(request: VNRequest, error: Error?) {
        
        guard let results = request.results as? [VNCoreMLFeatureValueObservation] else {
                fatalError("huh")
        }
        
        for classification in results {
            print("Estimated price: " , classification.featureValue, // the scene label
                classification.confidence)
            
            // Ugly code but i think this was the only way to get what i wanted, round the featureValue to one decimal values
            let price = classification.featureValue
            let stringPrice = Double((String(describing: price.multiArrayValue![0])))
            roundedPrice = Double(round(10*stringPrice!)/10)
            priceLabel.text = ("Price: "+String(roundedPrice)+" €")
        }
        
    }
    
    func doEvaluation(image: UIImage) {
        
        let buffer = self.buffer(from: image)
        var model: VNCoreMLModel
        
        switch status {
        case "Gloves":
            model = try! VNCoreMLModel(for: glovesModel.model)
            print("using gloves model")
        case "Shirts":
            model = try! VNCoreMLModel(for: shirtsModel.model)
            print("using shirts model")
        case "Shoes":
            model = try! VNCoreMLModel(for: shoesModel.model)
            print("using shoes model")
        case "Hats":
            model = try! VNCoreMLModel(for: hatsModel.model)
            print("using hats model")
        case "Pants":
            model = try! VNCoreMLModel(for: pantsModel.model)
            print("using pants model")
        case "Coats":
            model = try! VNCoreMLModel(for: coatsModel.model)
            print("using coats model")
        default:
            model = try! VNCoreMLModel(for: shoesModel.model)
            print("using default case")
        }

        let request = VNCoreMLRequest(model: model, completionHandler: myResultsMethod)
        let handler = VNImageRequestHandler(cvPixelBuffer: buffer!)
        try? handler.perform([request])
    }
    
    @IBAction func saveButtonClick(_ sender: UIButton) {
        addItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
