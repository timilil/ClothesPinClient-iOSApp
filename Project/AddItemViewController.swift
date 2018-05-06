//
//  AddItemViewController.swift
//  Project
//
//  Created by Timi Liljeström on 19.4.2018.
//  Copyright © 2018 Timi Liljeström. All rights reserved.
//

import UIKit
import os.log

class AddItemViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    let provider = Provider()
    var pickedImage: UIImage?
    var categoryName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationController?.navigationBar.barTintColor = UIColorFromHex(rgbValue: 0x00C78C, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        textField.delegate = self
        saveButton.tintColor = UIColor.black
        updateSaveButtonState()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        textField.resignFirstResponder()
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
            else {
                fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        // Set photoImageView to display the selected image.
        photoImageView.image = selectedImage
        self.pickedImage = photoImageView.image
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
        updateSaveButtonState()
    }
    
    func textFieldShouldReturn(_ textfield: UITextField) -> Bool {
        // Hide the keyboard when user presses done in keyboard
        textfield.resignFirstResponder()
        return true
    }
    
    // happens after textFieldShouldReturn
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the Save button while editing.
        saveButton.isEnabled = false
    }
    
    private func updateSaveButtonState() {
        // Disable the Save button if the text field is empty or no image selected.
        
        let text = textField.text ?? ""
        
        if pickedImage != nil && !text.isEmpty && ((Double(textField.text!) != nil) == true) {
            saveButton.isEnabled = true
            saveButton.tintColor = UIColor.white
        } else {
            saveButton.isEnabled = false
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        super.prepare(for: segue, sender: sender)
        
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
         os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
         return
         }
        
        let price = textField.text ?? ""
        let photo = photoImageView.image
        
        //soldItem = Image(price: Double(price)!, photo: photo)
        if pickedImage != nil {
            //provider.upload(image: evaluatedImage)
            provider.newUpload(category: categoryName, price: price, image: photo!)
        }
    }
}
