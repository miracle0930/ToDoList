//
//  Item.swift
//  WhatToDoDemo
//
//  Created by 管 皓 on 2018/1/12.
//  Copyright © 2018年 Hao Guan. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var marked: Bool = false
    @objc dynamic var dateCreated: Date?
    var parentCatagory = LinkingObjects(fromType: Catagory.self, property: "items")
    
}
