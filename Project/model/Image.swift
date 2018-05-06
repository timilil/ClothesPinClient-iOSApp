//
//  image.swift
//  Project
//
//  Created by Timi Liljeström on 4.4.2018.
//  Copyright © 2018 Timi Liljeström. All rights reserved.
//

import UIKit

class Image {
    
    //MARK: Properties
    var price: Double
    var photo: UIImage?
    
    
    //MARK: Initialization
    init?(price: Double, photo: UIImage?) {
        // Initialization should fail if there is no name or if the rating is negative.
        guard price != nil else {
            return nil
        }
        
        guard photo != nil else {
            return nil
        }
        
        self.price = price
        self.photo = photo
    }
}


