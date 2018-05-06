//
//  MyItemsTableViewController.swift
//  Project
//
//  Created by Timi Liljeström on 24.4.2018.
//  Copyright © 2018 Timi Liljeström. All rights reserved.
//

import UIKit
import CoreData

class MyItemsTableViewController: UITableViewController {

    let provider = Provider()
    let cellSpacingHeight: CGFloat = 8
    var alertController: UIAlertController?
    var imageItems: [UIImage] = []
    var prices: [String] = []
    var categoryNames: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadImageItem()
    }
    
    func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
    
    func loadImageItem() {
        let context = AppDelegate.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ImageItem")
        // let request: NSFetchRequest<ImageItem> = ImageItem.fetchRequest()
        request.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(request)
            if results.count > 0 {
                print("Item: Data Found:")
                for result in results as! [NSManagedObject] {
                    if let imageData = result.value(forKey: "photo") as? NSData {
                        if let image = UIImage(data:imageData as Data) {
                            //print("found")
                            print(image)
                            //imageView.image = photoinData
                            imageItems.append(image)
                            //imageItems.insert(image, at: 0)
                        }
                    }
                    if let priceInData = result.value(forKey: "price") as? Double {
                        let priceString:String = String(priceInData)
                        prices.append(priceString)
                        //prices.insert(priceString, at: 0)
                    }
                    if let categoryName = result.value(forKey: "categoryname") as? String {
                        categoryNames.append(categoryName)
                        //categoryNames.insert(categoryName, at: 0)
                    }
                }
            } else {
                print("No data found")
            }
            
        } catch {
            print ("Error Loading")
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
        }
        
        self.alertController!.addAction(cancelAction)
        
        self.present(self.alertController!, animated: true, completion: nil)
    }
    
    @objc func pressedDeleteButton(sender: UIButton){
        let buttonTag = sender.tag
        print(buttonTag)
        
        let deleteAlert = UIAlertController(title: "Delete", message: "After deleting, this item will be lost.", preferredStyle: UIAlertControllerStyle.alert)
        
        deleteAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            // Handle Ok logic here
            let context = AppDelegate.viewContext
            
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ImageItem")
            request.returnsObjectsAsFaults = false
            do {
                let results = try context.fetch(request)
                context.delete(results[buttonTag] as! NSManagedObject)
                
                self.imageItems.remove(at: buttonTag)
                self.categoryNames.remove(at: buttonTag)
                self.prices.remove(at: buttonTag)
                
                print("Deleted")
                try context.save()
                self.tableView.reloadData()
            } catch {
                print ("Error Deleting")
            }
        }))
        
        deleteAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            print("Canceled")
        }))
        present(deleteAlert, animated: true, completion: nil)
    }
    
    @objc func saveAsSoldButton(sender: UIButton){
        let buttonTag = sender.tag
        print(buttonTag)
        let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: buttonTag)) as! MyItemsTableViewCell
        
        if !(cell.priceEdit.text!.isEmpty) && ((Double(cell.priceEdit.text!) != nil) == true) {
            let saveAlert = UIAlertController(title: "Save", message: "This item will go to all categories list, which is where all the public items are located.", preferredStyle: UIAlertControllerStyle.alert)
            
            saveAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                
                self.provider.newUpload(category: self.categoryNames[buttonTag].lowercased(), price: cell.priceEdit.text!, image: self.imageItems[buttonTag])
                
                let context = AppDelegate.viewContext
                
                let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ImageItem")
                request.returnsObjectsAsFaults = false
                do {
                    let results = try context.fetch(request)
                    context.delete(results[buttonTag] as! NSManagedObject)
                    
                    self.imageItems.remove(at: buttonTag)
                    self.categoryNames.remove(at: buttonTag)
                    self.prices.remove(at: buttonTag)
                    
                    try context.save()
                    
                    self.showAlertMsg(title: "Uploaded", message: "Successfully uploaded to the server!")
                    self.tableView.reloadData()
                } catch {
                    print ("Error")
                    self.showAlertMsg(title: "Error", message: "Oops! Something went wrong.")
                }
            }))
            
            saveAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                print("Canceled")
            }))
            
            present(saveAlert, animated: true, completion: nil)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        //return 1
        return imageItems.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return imageItems.count
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cellSpacingHeight
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "MyItemsTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MyItemsTableViewCell else {
            fatalError("The dequeued cell is not an instance of CategoryTableViewCell.")
        }
        
        guard let image = self.imageItems[indexPath.section] as UIImage? else {
            fatalError("Item not found from fetched results controller")
        }
        guard let price = self.prices[indexPath.section] as String? else {
            fatalError("Item not found from fetched results controller")
        }
        guard let categoryname = self.categoryNames[indexPath.section] as String? else {
            fatalError("Item not found from fetched results controller")
        }
        
        // Configure the cell...
        
        cell.photoImageView.image = image
        cell.priceEdit.text = price
        cell.categoryName.text = categoryname
        
        cell.deleteButton.tag = indexPath.section
        cell.deleteButton.addTarget(self, action: #selector(pressedDeleteButton(sender:)) , for: .touchUpInside)
        cell.deleteButton.setTitleColor(UIColor.red, for: UIControlState.normal)
        
        cell.saveAsSoldItemButton.tag = indexPath.section
        cell.saveAsSoldItemButton.addTarget(self, action: #selector(saveAsSoldButton(sender:)) , for: .touchUpInside)
        cell.saveAsSoldItemButton.layer.cornerRadius = 10
        cell.saveAsSoldItemButton.setTitleColor(UIColorFromHex(rgbValue: 0x28AE7B, alpha: 1), for: UIControlState.normal)
        
        cell.layer.borderColor = UIColorFromHex(rgbValue: 0x00C78C, alpha: 1).cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 10
        cell.clipsToBounds = true
        
        return cell
    }
}
