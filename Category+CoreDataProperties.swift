//
//  Category+CoreDataProperties.swift
//  Project
//
//  Created by Timi Liljeström on 16.4.2018.
//  Copyright © 2018 Timi Liljeström. All rights reserved.
//
//

import Foundation
import CoreData


extension Category {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Category> {
        return NSFetchRequest<Category>(entityName: "Category")
    }

    @NSManaged public var name: String?

}
