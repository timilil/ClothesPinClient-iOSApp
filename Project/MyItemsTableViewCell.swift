//
//  MyItemsTableViewCell.swift
//  Project
//
//  Created by Timi Liljeström on 24.4.2018.
//  Copyright © 2018 Timi Liljeström. All rights reserved.
//

import UIKit

class MyItemsTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var photoImageView: UIImageView!
    //@IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var priceEdit: UITextField!
    @IBOutlet weak var categoryName: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var saveAsSoldItemButton: UIButton!
    
    func textFieldShouldReturn(_ textfield: UITextField) -> Bool {
        // Hide the keyboard when user presses done in keyboard
        priceEdit.resignFirstResponder()
        return true
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        priceEdit.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
