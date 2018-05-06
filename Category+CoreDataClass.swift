//
//  Category+CoreDataClass.swift
//  Project
//
//  Created by Timi Liljeström on 16.4.2018.
//  Copyright © 2018 Timi Liljeström. All rights reserved.
//
//

import Foundation
import CoreData


public class Category: NSManagedObject {
    
    class func getOrCreateCategoryWith (name: String, context: NSManagedObjectContext) throws -> Category? {
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        request.predicate = NSPredicate(format: "name = %@", name)
        do {
            let matchingCategories = try context.fetch(request)
            if matchingCategories.count == 1 {
                return matchingCategories[0]
            } else if (matchingCategories.count == 0) {
                let newCategory = Category (context: context)
                return newCategory
            } else {
                print("Database inconsitent found equal categories")
                return matchingCategories[0]
            }
            
        } catch {
            throw error
        }
    }

}
