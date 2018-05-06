//
//  CategoryObserver.swift
//  Project
//
//  Created by Timi Liljeström on 28.3.2018.
//  Copyright © 2018 Timi Liljeström. All rights reserved.
//

import Foundation

protocol CategoryObserver {
    func update(imageItems: [[String:Any]])
}
