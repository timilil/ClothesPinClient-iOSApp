//
//  ImageItem+CoreDataProperties.swift
//  Project
//
//  Created by Timi Liljeström on 27.4.2018.
//  Copyright © 2018 Timi Liljeström. All rights reserved.
//
//

import Foundation
import CoreData


extension ImageItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ImageItem> {
        return NSFetchRequest<ImageItem>(entityName: "ImageItem")
    }

    @NSManaged public var photo: NSData?
    @NSManaged public var price: Double
    @NSManaged public var categoryname: String?

}
