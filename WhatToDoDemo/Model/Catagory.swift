//
//  Catagory.swift
//  WhatToDoDemo
//
//  Created by 管 皓 on 2018/1/12.
//  Copyright © 2018年 Hao Guan. All rights reserved.
//

import Foundation
import RealmSwift

class Catagory: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var color: String = ""
    let items = List<Item>()
    
    
    
    
}
