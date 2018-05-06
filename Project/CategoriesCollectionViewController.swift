//
//  CategoriesCollectionViewController.swift
//  Project
//
//  Created by Timi Liljeström on 22.4.2018.
//  Copyright © 2018 Timi Liljeström. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class CategoriesCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var items = ["Shoes", "Coats", "Hats", "Pants", "Shirts", "Gloves"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CategoriesCollectionViewCell
        
        // Configure the cell
    
        let borderColor: CGColor! = UIColorFromHex(rgbValue: 0x00C78C, alpha: 1).cgColor
        let borderWidth: CGFloat = 1
        
        if self.items[indexPath.item] == "Shoes" {
            cell.photoImageView.image = #imageLiteral(resourceName: "Boots")
        }
        if self.items[indexPath.item] == "Coats" {
            cell.photoImageView.image = #imageLiteral(resourceName: "Coats")
        }
        if self.items[indexPath.item] == "Hats" {
            cell.photoImageView.image = #imageLiteral(resourceName: "Hats")
        }
        if self.items[indexPath.item] == "Pants" {
            cell.photoImageView.image = #imageLiteral(resourceName: "Pants")
        }
        if self.items[indexPath.item] == "Shirts" {
            cell.photoImageView.image = #imageLiteral(resourceName: "Shirts")
        }
        if self.items[indexPath.item] == "Gloves" {
            cell.photoImageView.image = #imageLiteral(resourceName: "Gloves")
        }
        
        cell.layer.borderColor = borderColor
        cell.layer.borderWidth = borderWidth
        cell.layer.cornerRadius = 15
        
        return cell
    }
    
    func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let numberOfSets = CGFloat(2)
        
        let width = (collectionView.frame.size.width - (numberOfSets * view.frame.size.width / 15))/numberOfSets
        
        let height = collectionView.frame.size.height / 4
        
        return CGSize(width: width, height: height);
    }
    
    // UICollectionViewDelegateFlowLayout method
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        
        let cellWidthPadding = collectionView.frame.size.width / 30
        let cellHeightPadding = collectionView.frame.size.height / 4
        return UIEdgeInsets(top: 10, left: cellWidthPadding, bottom: cellHeightPadding, right: cellWidthPadding)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
        collectionView.deselectItem(at: indexPath, animated: false)
        
        let storyBoard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextScene = storyBoard.instantiateViewController(withIdentifier: "SoldItemsTableViewController") as! SoldItemsTableViewController
        nextScene.title = self.items[indexPath.item]
        
        self.navigationController?.pushViewController(nextScene, animated: true)
    }
}
