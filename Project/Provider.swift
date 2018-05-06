//
//  Provider.swift
//  Project
//
//  Created by Timi Liljeström on 28.3.2018.
//  Copyright © 2018 Timi Liljeström. All rights reserved.
//

import Foundation
import UIKit

class Provider: CategoryObservable {
    
    private var observers = [CategoryObserver]()
    
    func notifyObservers(imageItems: [[String:Any]]) {
        for observer in observers {
            observer.update(imageItems: imageItems)
        }
    }
    
    func registerObserver(observer: CategoryObserver){
        if observers.index(where:{($0 as AnyObject) === (observer as AnyObject)}) == nil {
            observers.append(observer)
        }
    }
    
    func deRegisterObserver(observer: CategoryObserver){
        if let index = observers.index(where:{($0 as AnyObject) === (observer as AnyObject)}) {
            observers.remove(at: index)
        }
    }
    
    func getDataToDisplay(itemType: String) {
        
        guard let url = URL(string: "http://localhost:5000/\(itemType)") else {
            fatalError("Failed to create URL")
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Client error \(error)")
            }
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                // handle server error
                return
            }
            if let data = data, let string = String(data: data, encoding: .utf8) {
                // Process the data
                let json = try? JSONSerialization.jsonObject(with: data, options: []) as! [String: [Any]]
                
                let innerJson = json!["images"]!
                
                let arrayOfStrings = innerJson as! [String]
                
                var resultArray = [[String:Any]]()
                
                // there's probably an easier way to do this, but it works...
                for str in arrayOfStrings {
                    resultArray.append(self.convertToDict(text: str)!)
                }
                
                DispatchQueue.main.async {
                    self.notifyObservers(imageItems: resultArray)
                }
            }
        }
        task.resume()
    }
    
    // it was needed as a helper function because God and json were in league against us...
    func convertToDict(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    func newUpload(category: String, price: String, image: UIImage) {
        let url = URL(string: "http://localhost:5000")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("text/plain", forHTTPHeaderField: "Accept")
        
        let imageData = UIImagePNGRepresentation(image)
        let base64String = imageData?.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: NSData.Base64EncodingOptions.RawValue(0)))
        
        let jsonContent = ["category": category, "price": price, "encodedImage": base64String]
        try? request.httpBody = JSONSerialization.data(withJSONObject: jsonContent, options: JSONSerialization.WritingOptions(rawValue: 0))
        
        let task = URLSession.shared.uploadTask(with: request, from: request.httpBody) { data, response, error in
            if let error = error {
                print ("error: \(error)")
                return
            }
            
            if let response = response as? HTTPURLResponse {
                print("response \(response.statusCode)")
            }
            
            guard let response = response as? HTTPURLResponse,
                (200...299).contains(response.statusCode) else {
                    print ("server error")
                    return
            }
            if let mimeType = response.mimeType,
                mimeType == "application/json",
                let data = data,
                let dataString = String(data: data, encoding: .utf8) {
                print ("got data: \(dataString)")
            }
        }
        task.resume()
    }
}

