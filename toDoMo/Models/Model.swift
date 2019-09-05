//
//  Data.swift
//  toDoMo
//
//  Created by deniz ardali on 9/1/19.
//  Copyright © 2019 deniz ardali krstic. All rights reserved.
//

import Foundation
import RealmSwift

class Model: Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated : Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    
   
}


