//
//  SoldItemTableViewCell.swift
//  Project
//
//  Created by Timi Liljeström on 18.4.2018.
//  Copyright © 2018 Timi Liljeström. All rights reserved.
//

import UIKit

class SoldItemTableViewCell: UITableViewCell {

    //MARK: Properties
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
