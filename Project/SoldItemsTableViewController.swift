//
//  SoldItemsTableViewController.swift
//  Project
//
//  Created by Timi Liljeström on 18.4.2018.
//  Copyright © 2018 Timi Liljeström. All rights reserved.
//

import UIKit

class SoldItemsTableViewController: UITableViewController, CategoryObserver {
    
    var soldItems = [Image]()
    let provider = Provider()
    let cellSpacingHeight: CGFloat = 8
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.tableView.backgroundColor = UIColorFromHex(rgbValue: 0xe9f6f1, alpha: 1)
        provider.registerObserver(observer: self)
        provider.getDataToDisplay(itemType: self.title!.lowercased())
    }
    
    func update(imageItems: [[String:Any]]) {
        for imageItem in imageItems {
            let imageDataDecoded:NSData = NSData(base64Encoded: imageItem["image"]! as! String, options: NSData.Base64DecodingOptions(rawValue: 0))!
            let decodedImage:UIImage = UIImage(data: imageDataDecoded as Data)!
            //print(decodedImage)
            let price = imageItem["price"]! as! Double
            let roundedPrice = Double(round(10*price)/10)
            
            guard let item = Image(price: roundedPrice, photo: decodedImage) else {
                fatalError("Unable to instantiate image item")
            }
            soldItems.append(item)
        }
        self.tableView.reloadData()
    }
    
    func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    // section count is soldItems count because it was needed to get the spacing between every cell
    override func numberOfSections(in tableView: UITableView) -> Int {
        //return 1
        return soldItems.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return soldItems.count
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
        let cellIdentifier = "SoldItemTableViewCell"

        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SoldItemTableViewCell  else {
            fatalError("The dequeued cell is not an instance of SoldItemTableViewCell.")
        }
        
        // Configure the cell...
        let item = soldItems[indexPath.section]
        cell.price.text = "Price: "+String(item.price)+" €"
        cell.photoImageView.image = item.photo
        cell.layer.borderColor = UIColorFromHex(rgbValue: 0x00C78C, alpha: 1).cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 10
        cell.clipsToBounds = true
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let destination = segue.destination as? UINavigationController {
            if let targetController = destination.topViewController as? AddItemViewController {
                targetController.categoryName = self.title!.lowercased()
            }
        }
    }
    
    // MARK: - Navigation
    
    @IBAction func unwindToSoldItemsList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? AddItemViewController {
            print("Saved")
        }
    }
}
