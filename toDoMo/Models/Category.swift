//
//  Category.swift
//  toDoMo
//
//  Created by deniz ardali on 9/3/19.
//  Copyright © 2019 deniz ardali krstic. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
  @objc dynamic var name : String = ""
    let items = List<Model>()
}
