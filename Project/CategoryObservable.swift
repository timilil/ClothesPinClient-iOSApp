//
//  CategoryObservable.swift
//  Project
//
//  Created by Timi Liljeström on 28.3.2018.
//  Copyright © 2018 Timi Liljeström. All rights reserved.
//

import Foundation

protocol CategoryObservable{
    func notifyObservers(imageItems: [[String:Any]])
    func registerObserver(observer: CategoryObserver)
    func deRegisterObserver(observer: CategoryObserver)
}
