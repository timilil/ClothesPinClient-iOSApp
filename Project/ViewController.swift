//
//  ViewController.swift
//  Project
//
//  Created by Timi Liljeström on 27.3.2018.
//  Copyright © 2018 Timi Liljeström. All rights reserved.
//

import UIKit
import os.log

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var display: UILabel!
    
    @IBOutlet weak var hwPicker: UIPickerView!
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    @IBOutlet weak var evaluateButtonOutlet: UIButton!
    
    var pickerCategories: [String] = ["Shoes", "Coats", "Gloves", "Hats", "Pants", "Shirts"]
    var pickedImage: UIImage?
    var status: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        evaluateButtonOutlet.backgroundColor = UIColorFromHex(rgbValue: 0xe9f6f1, alpha: 1)
        evaluateButtonOutlet.layer.cornerRadius = 10
        
        hwPicker.delegate = self
        hwPicker.dataSource = self
        
        updateSaveButtonState()
    }
    
    func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerCategories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let attributedString = NSAttributedString(string: pickerCategories[row], attributes: [NSAttributedStringKey.foregroundColor : UIColorFromHex(rgbValue: 0x28AE7B, alpha: 1)])
        return attributedString
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (component == 0) {
            print(row)
        } else {
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
            else {
                fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        // Set photoImageView to display the selected image.
        photoImageView.image = selectedImage
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
        pickedImage = selectedImage;
        updateSaveButtonState()
    }
    
    @IBAction func evaluateButton(_ sender: UIButton) {
        /*if let evaluatedImage = pickedImage {
            provider.upload(image: evaluatedImage)
        }*/
    }
    
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .photoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    private func updateSaveButtonState() {
        // Disable the Save button if no image selected.
        if pickedImage != nil {
            evaluateButtonOutlet.isEnabled = true
            evaluateButtonOutlet.setTitleColor(UIColor.white, for: UIControlState.normal)
            evaluateButtonOutlet.backgroundColor = UIColorFromHex(rgbValue: 0x28AE7B, alpha: 1)
        } else {
            evaluateButtonOutlet.isEnabled = false
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let evaluatedViewController = segue.destination as? EvaluatedViewController {
            let chosen = pickerCategories[hwPicker.selectedRow(inComponent: 0)]
            evaluatedViewController.status = (chosen)
            
            if let selectedImage = pickedImage { evaluatedViewController.pickedImage = selectedImage
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

